# Reproduction of spurious call targets caused by over-approximation of the type
# of `self` flowing through mixin methods.

module BarMixin
  def bar
    baz
  end
end

class MixinTestA
  include BarMixin

  def foo
    bar
  end

  def baz
    # This only calls MixinTestA::qux, but we resolve it to both MixinTestA::qux and MixinTestB::qux.
    qux
  end

  def qux
    puts "MixinTestA::qux"
  end
end

class MixinTestB
  include BarMixin

  def foo
    bar
  end

  def baz
    # This only calls MixinTestB::qux, but we resolve it to both MixinTestA::qux and MixinTestB::qux.
    qux
  end

  def qux
    puts "MixinTestB::qux"
  end
end