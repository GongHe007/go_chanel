require "go_chanel/chanel"
module GoChanel
  class Pool
    attr_reader :size, :proc
    def initialize(size = 1, &proc)
      @size = size
      @proc = proc
    end

    def |(pool)
      pipe = Pipe.new
      pipe.pools << self
      pipe.pools << pool
      pipe
    end
  end
end
