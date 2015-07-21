module GoChanel
  class ErrNotifier
    @@notifier = nil
    @@std_out = true
    @@mutex = Mutex.new
    def self.register(notifier, std_out = false)
      @@notifier = notifier
      @@std_out = std_out
      raise "notifier should have a func named as" unless notifier.respond_to?(:notify)
    end

    def self.std_out=(open = true)
      @@std_out = open
    end

    def self.notify(e)
      if @@std_out
        puts "Something wrong in Thread:"
        puts e
        puts e.backtrace
      end

      if @@notifier.present?
        @@mutex.synchronize do
          notifier.notify(e)
        end
      end
    end
  end
end
