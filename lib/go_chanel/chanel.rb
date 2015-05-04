# chanel is a FIFO queue.
# It will sleep when push into a channel with full buffer.
# It will sleep when pop from an empty channel
# It will raise Exception when push into a closed channel
# It will still work when pop form an empty channel
# just like go channel

module GoChanel
  class Chanel
    def initialize(cap_size = 1, objs = [])
      raise ChanelException.new("can not create a 0 size channel") if cap_size < 1

      @obj_mutex = Mutex.new
      @close_mutex = Mutex.new
      @cap_size = cap_size
      @objs = objs
      @closed = false
    end

    def push(obj)
      raise ChanelException.new("can not push to closed channel") if @closed

      while @objs.count >= @cap_size do
        raise ChanelException.new("can not push to closed channel") if @closed
        sleep(0.1)
      end

      @obj_mutex.synchronize do
        @objs.push(obj)
      end
    end

    def pop
      while @objs.count == 0 do
        return nil, false if @closed
        sleep(0.1)
      end

      obj = @obj_mutex.synchronize do
        @objs.shift
      end

      return obj, true
    end

    def size
      @objs.count
    end

    def cap
      @cap_size
    end

    def close
      @close_mutex.synchronize do
        @closed = true
      end
    end
  end

  class ChanelException < StandardError
  end
end
