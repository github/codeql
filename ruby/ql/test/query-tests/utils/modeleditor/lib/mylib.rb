require_relative "./other"

class A
  def initialize(x, y)
    @x = x
  end

  def foo(x, y, key1:, **kwargs, &block)
    block.call(x, y, key2: key1)

    yield x, y, key2: key1
  end

  def bar(x, *args)
  end

  def self.self_foo(x, y)
  end

  private

  def private_1(x, y)
  end

  class ANested
    def foo(x, y)
    end

    private

    def private_2(x, y)
    end
  end
end
