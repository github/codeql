class Foo
  def initialize(...)
    do_init(...)
  end

  def do_init(...)
    really_do_init(...)
  end

  def really_do_init(bar, baz:, &block)
    puts bar
    puts baz
    block.call
  end
end

Foo.new("hello", baz: "world") { || puts "!" }
