module GoChanel
  class Pipe
    attr_accessor :pools
    def self.|(pool)
      pipe = Pipe.new
      pipe.pools << pool
      pipe
    end

    def initialize
      @pools = []
    end

    def |(pool)
      @pools << pool
      self
    end

    def run(*args)
      raise PipeException.new("at_leaset pipe two pools") if @pools.count < 2
      concurrence_chan = GoChanel::Chanel.new(@pools.count)

      chans = build_chans

      start_pool = @pools.shift
      last_pool = @pools.pop

      Thread.new(args) do |params|
        begin
          GoChanel::Task.start_task(chans[0], *params, &start_pool.proc)
        rescue => e
          GoChanel::ErrNotifier.notify(e)
        ensure
          concurrence_chan.push(true)
        end
      end

      #no head and tail
      @pools.each_with_index do |pool, i|
        Thread.new do
          begin
            GoChanel::Task.normal_task(chans[i], chans[i + 1], pool.size, &pool.proc)
          rescue => e
            GoChanel::ErrNotifier.notify(e)
          ensure
            concurrence_chan.push(true)
          end
        end
      end

      Thread.new do
        begin
          GoChanel::Task.end_task(chans[-1], last_pool.size, &last_pool.proc)
        rescue => e
          GoChanel::ErrNotifier.notify(e)
        ensure
          concurrence_chan.push(true)
        end
      end

      concurrence_chan.cap.times do
        concurrence_chan.pop
      end
    end

    private

    def build_chans
      chans = []

      @pools.each_with_index do |pool, i|
        next if i == 0
        chans << GoChanel::Chanel.new(pool.size)
      end

      chans
    end
  end

  class PipeException < StandardError
  end
end
