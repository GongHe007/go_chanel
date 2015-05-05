# GoChanel
模仿golang中的channel。chanel是因为我拼写错了。。。。

## Installation

Add this line to your application's Gemfile:

    gem 'go_chanel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install go_chanel

## Usage

最重要的组成是channel。也就是`GOChanel::Chanel`。它是所有的核心。
一个channel是这样的：
* 它是一个FIFO的队列，它支持push、pop、close。默认容量是1
* 向一个Buffer满了的channel中push会阻塞
* 向一个closed的channel中push会抛出异常
* 从一个Buffer空了的channel中pop会阻塞
* 从一个closed的channle中pop不会抛异常，会返回一个变量说channel关闭了
总之他就是在模拟golang中的channel

###GoChanel::Chanel的用法例子
```ruby
chanel = GoChanel::Chanel.new # 新建了一个容量为1的chanel
chanel.push(1) #向chanel中push一次，这时还不会阻塞
obj, ok = chanel.pop #obj是队列里的东西，ok是说这个chanel有没有关闭，如果close的话ok就会是false
chanel.close #这个一般是在完成push之后关闭
```

更复杂点的用法，一般是主线程只负责分线程。我喜欢这样的用法：
```ruby
def main
  concurrency_chan = GoChanel::Chanel.new
  Thread.new {
    puts "hello world"
    concurrency_chan.push(true)
  }
  concurrency_chan.pop
end
```

更复杂的用法, 也就是更高的并发

```ruby
def main
  finish_func1 = GoChanel::Chanel.new
  finish_func2 = GoChanel::Chanel.new
  buffer_chan = GoChanel::Chanel.new(128)
  Thread.new {
    func1(buffer_chan)
    finish_func1.push(true)
  }
  Thread.new {
    func2(buffer_chan)
    finish_func2.push(true)
  }
  finish_func1.pop
  finish_func2.pop
end
def func1(out_chan)
  1024.times do |i|
    out_chan.push(i)
  end
  out_chan.close
end
def func2(in_chan)
  concurrency_chan = GoChanel::Chanel.new(512) #512个并发
  while true do
    obj, ok = in_chan.pop
    break unless ok
    concurrency_chan.push(true)
    Thread.new(obj) do |str|
      puts str
      concurrency_chan.pop
    end
  end
end
```

###并发的Pipe
类似于linux中的pipe，一个pipe的定义是这样的
* 由至少2个pool组成
* 分为三类pool，头、中间、尾。头只有一个out_chan, 中间的有一个in_chan也有一个out_chan, 尾只有一个in_chan
* 对于中间和尾部的pool, 前一个pool的block返回值应该可以作为下一个pool block的输入
* 头pool比较特殊，其实他是单线程执行的，因为一般头pool是重cpu的操作，分成多个thread也没有意义，它的返回值是一个array，依次传递给下一个pool
用法如下,还是完成上一个复杂的例子，就会很简单

```ruby
pool1 = GoChanel::Pool.new(1) do
  1024.times.to_a
end
pool2 = GoChanle::Pool.new(512) do |i|
  puts i
end
pipe = pool1 | pool2
pipe.run
```

另一个例子

```ruby
pool1 = GoChanel::Pool.new do
  1024.times.map do |i|
    [i + 1, i + 2]
  end
end
pool2 = GoChanel::Pool.new(128) do |i, j|
  i + j #一般为IO操作，这里就最简单的表示了
end
pool3 = GoChanel::Pool.new(32) do |i|
  puts i
end
pipe = pool1 | pool2 | pool3
pipe.run
```

###很重要：记住Thread和Progress的区别
## Contributing

1. Fork it ( https://github.com/xuxiangyang/go_chanel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
