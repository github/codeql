class Foobar
  def foo1(name) # $ Source
    raise Blabity, 'Invalid thing' if name !~ /^[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*$/ # $ Alert // NOT OK
  end

  def foo2(name) # $ Source
    raise Blabity, 'Invalid thing' unless name !~ /^[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*$/ # $ Alert // NOT OK
  end

  def foo3(name)
    raise Blabity, 'Invalid thing' unless name !~ /\A[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*\z/ # OK
  end

  def foo4(name)  # $ Source
    raise Blabity, 'Invalid thing' unless not name !~ /^[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*$/ # $ Alert // NOT OK
  end
end
