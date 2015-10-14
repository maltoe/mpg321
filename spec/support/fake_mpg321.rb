require 'stringio'

class FakeMpg321
  attr_reader :stdin, :stdoe, :wait_thr

  def initialize
    @stdin    = StringIO.new
    @stdoe    = StringIO.new
    @wait_thr = FakeWaitThread.new
  end

  def open2e_returns
    [@stdin, @stdoe, @wait_thr]
  end

  def last_command
    @stdin.rewind
    cmd = @stdin.gets.strip until @stdin.eof?
    @stdin = StringIO.new
    cmd
  end

  def finish_playback
    @stdoe.rewind
    @stdoe.flush
    @stdoe.puts '@P 3'
    @stdoe.rewind
  end

  private

  class FakeWaitThread
    FakeExitStatus = Struct.new(:exitstatus)

    def value
      FakeExitStatus.new(0)
    end
  end
end
