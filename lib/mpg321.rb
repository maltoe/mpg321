require 'open3'
require 'timeout'

class Mpg321
  attr_reader :volume

  def initialize
    @volume = 50
    @paused = false
    @music_input, @stdout, @stderr, _thread = Open3.popen3("mpg321 -R mpg321_ruby")
    handle_stderr
    handle_stdout
    send_volume
  end

  def pause
    @paused = !@paused
    @music_input.puts "P"
  end

  def stop
    @paused = !@paused
    @music_input.puts "S"
  end

  def paused?
    @paused
  end

  def play song_list
    @paused = !@paused
    @song_list = song_list
    if song_list.class == Array
      @list = true
      play_song @song_list.shift
    else
      @list = false
      play_song song_list
    end
  end

  def volume_up volume
    @volume += volume
    @volume = [@volume, 100].min
    send_volume
  end

  def volume_down volume
    @volume -= volume
    @volume = [@volume, 0].max
    send_volume
  end

  def volume= volume
    if volume < 0
      @volume = 0
    elsif volume > 100
      @volume = 100
    else
      @volume = volume
    end
    send_volume
  end

  private

  def play_song song
    @music_input.puts "L #{song}"
  end

  def send_volume
    @music_input.puts "G #{@volume}"
  end

  def handle_stderr
    Thread.new do
      loop do

        #Not sure how to test this yet
        begin
          Timeout::timeout(1) { @stderr.readline }
        rescue Timeout::Error
          play @song_list if @list && !@paused
        end

      end
    end
  end

  def handle_stdout
    Thread.new do
      loop do
        #Not sure how to test this yet
        @stout.readline
        if @list && @line.match(/@P 3/)
          play @song_list
        end
      end
    end
  end
end
