require "go_chanel/version"
require "go_chanel/chanel"
require "go_chanel/pool"
require "go_chanel/pipe"
require "go_chanel/task"
require "go_chanel/err_notifier"

module GoChanel
  def self.go(*args, &proc)
    Thread.new(args) do |params|
      proc.call(*params)
    end
  end
end
