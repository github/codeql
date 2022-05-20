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