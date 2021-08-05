module A
  class B
    def f
      g 1
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
  class D
    def initialize
      x, y = [1, 2]
      y
    end

    def h y
      A::B.new.g y
      UnknownClass.some_method
    end
  end
end

C::D.new
