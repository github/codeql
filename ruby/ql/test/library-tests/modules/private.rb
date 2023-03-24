class E
  private def private1
  end

  def public
  end

  def private2
  end
  private :private2

  private

  def private3
  end

  def private4
  end
  
  def self.public2
  end
  
  private_class_method def self.private5
  end
  
  def self.private6
  end
  private_class_method :private6

  protected

  def protected1
  end

  def protected2
  end

  def self.public3
  end

  def private7
  end
  private :private7

  private

  def private8
  end
end

def private_on_main
end

E.new.private1
E.new.private2
E.new.private3
E.new.private4
E.new.public

private_on_main

module F
  private def private1
  end

  def public
  end

  def private2
  end
  private :private2

  private

  def private3
  end

  def private4
  end
end

class PrivateOverride1
  private def m1
      puts "PrivateOverride1#m1"
  end

  private def m2
      puts "PrivateOverride1#m2"
  end

  def call_m1
      m1
  end
end

class PrivateOverride2 < PrivateOverride1
  private def m1
      puts "PrivateOverride2#m1"
      m2
      PrivateOverride1.new.m1 # NoMethodError
  end
end

PrivateOverride2.new.call_m1
PrivateOverride2.new.m1 # NoMethodError
