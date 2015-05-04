require 'test/unit'
require 'pry'

class TestPipe < Test::Unit::TestCase
  def test_pipe
    count = 0
    pool1 = GoChanel::Pool.new do
      1
    end

    pool2 = GoChanel::Pool.new do |i|
      [i + 1, i + 2]
    end

    pool3 = GoChanel::Pool.new do |i, j|
      count = i + j
    end

    pipe = pool1 | pool2 | pool3
    pipe.run

    assert_equal 5, count
  end

  def test_pipe_at_least_2_pool
    pool1 = GoChanel::Pool.new(1) do |i|
      i
    end

    pipe = GoChanel::Pipe | pool1
    assert_raise GoChanel::PipeException do
      pipe.run
    end
  end
end
