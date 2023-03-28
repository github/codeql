class Foobar
  def foo1(name)
    raise Blabity, 'Invalid thing' if name !~ /^[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*$/ # NOT OK
  end

  def foo2(name)
    raise Blabity, 'Invalid thing' unless name !~ /^[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*$/ # NOT OK
  end

  def foo3(name)
    raise Blabity, 'Invalid thing' unless name !~ /\A[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*\z/ # OK
  end

  def foo4(name) 
    raise Blabity, 'Invalid thing' unless not name !~ /^[A-Za-z0-9\+\-_]+(\/[A-Za-z0-9\+\-_]+)*$/ # NOT OK
  end
end
