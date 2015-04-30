require "go_chanel/version"
require "go_chanel/chanel"

module GoChanel
  def self.go(*args, &proc)
    Thread.new do
      proc.call(*args)
    end
  end
end
