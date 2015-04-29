require 'test/unit'
require 'mocha/test_unit'

class TestChanel < Test::Unit::TestCase
  def test_0_cap_new_will_raise
    assert_raise GoChanel::ChanelException do
      GoChanel::Chanel.new(0)
    end
  end

  def test_push_to_closed_channel_will_raise
    chanel = GoChanel::Chanel.new
    chanel.close

    assert_raise GoChanel::ChanelException do
      chanel.push(2)
    end
  end

  def test_pop_from_closed_channel_will_not_raise
    chanel = GoChanel::Chanel.new
    chanel.push(1)
    chanel.close

    assert_nothing_raised do
      chanel.pop
    end
  end

  def test_pop_from_closed_will_return_not_ok
    chanel = GoChanel::Chanel.new
    chanel.push(1)
    chanel.close

    assert_equal [1, true], chanel.pop
    assert_equal [nil, false], chanel.pop
  end

  def test_channel_is_fifo
    chanel = GoChanel::Chanel.new(3)
    chanel.push(1)
    chanel.push(2)
    chanel.push(3)

    assert_equal 1, chanel.pop.first
    assert_equal 2, chanel.pop.first
    assert_equal 3, chanel.pop.first
  end

  def test_empty_chanel_pop_will_sleep
    chanel = GoChanel::Chanel.new
    chanel.push(1)
    chanel.pop

    chanel.stubs(:sleep).raises(Exception)

    assert_raise Exception do
      chanel.pop
    end
  end

  def test_full_chanel_push_will_sleep
    chanel = GoChanel::Chanel.new
    chanel.push(1)
    chanel.stubs(:sleep).raises(Exception)

    assert_raise Exception do
      chanel.push(1)
    end
  end
end
