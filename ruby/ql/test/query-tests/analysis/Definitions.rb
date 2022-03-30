module A
  SOME_CONSTANT = 1

  class B
    def f
      g SOME_CONSTANT
    end

    def g x
      x
    end

    def h
      f
    end
  end
end

module C
  @@a = 1

  def self.a
    @@a
  end

  class D
    @@b = 2

    def initialize
      @e = 1
      x, y = [1, 2]
      y
    end

    def h y
      A::B.new.g y
      UnknownClass.some_method
      @f = 2
      @e
      @f
      @@b
    end
  end
end

C::D.new
