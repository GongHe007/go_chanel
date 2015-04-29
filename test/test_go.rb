require 'test/unit'

class TestGo < Test::Unit::TestCase
  def test_go
    finish_push_chanel = GoChanel::Chanel.new
    finish_pop_chanel = GoChanel::Chanel.new
    chanel = GoChanel::Chanel.new
    GoChanel.go do
      chanel.push(1)
      finish_push_chanel.push(true)
    end


    GoChanel.go do
      puts chanel.pop
      finish_pop_chanel.push(true)
    end
    finish_push_chanel.pop
    finish_pop_chanel.pop
  end
end
