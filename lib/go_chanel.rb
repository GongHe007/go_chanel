require "go_chanel/version"
require "go_chanel/chanel"

module GoChanel
  def self.go(&proc)
    Thread.new do
      proc.call
    end
  end
end
