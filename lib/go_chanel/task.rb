# -*- coding: utf-8 -*-
module GoChanel
  class Task
    def self.normal_task(in_chan, out_chan, concurrence_count = 1, &proc)
      concurrence_chan = GoChanel::Chanel.new(concurrence_count)
      while true do
        args, ok = in_chan.pop
        break unless ok
        concurrence_chan.push(true)
        Thread.new(args) do |params|
          begin
            result = proc.call(*params)
            out_chan.push(result)
          rescue => e
            GoChanel::ErrNotifier.notify(e)
          ensure
            concurrence_chan.pop
          end
        end
      end

      while concurrence_chan.size > 0 do
        sleep(0.1)
      end
      out_chan.close
    end

    def self.start_task(out_chan, *args, &proc)
      concurrence_chan = GoChanel::Chanel.new
      Thread.new do
        begin
          [proc.call(*args)].flatten.each do |result|
            out_chan.push(result)
          end
        rescue => e
          GoChanel::ErrNotifier.notify(e)
        ensure
          concurrence_chan.push(true)
        end
      end
      concurrence_chan.pop
      out_chan.close
    end

    def self.end_task(in_chan, concurrence_count, &proc)
      concurrence_chan = GoChanel::Chanel.new(concurrence_count)
      while true do
        args, ok = in_chan.pop
        break unless ok
        concurrence_chan.push(true)
        Thread.new(args) do |params|
          begin
            proc.call(*params)
          rescue => e
            GoChanel::ErrNotifier.notify(e)
          ensure
            concurrence_chan.pop
          end
        end
      end

      while concurrence_chan.size > 0 do
        sleep(0.1)
      end
    end
  end
end
