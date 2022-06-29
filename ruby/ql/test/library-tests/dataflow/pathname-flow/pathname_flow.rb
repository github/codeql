require 'pathname'

def m_new
    pn = Pathname.new(source 'a')
    sink pn # $ hasTaintFlow=a
end

def m_plus
  a = Pathname.new(source 'a')
  b = Pathname.new(source 'b')
  sink(a + b) # $ hasTaintFlow=a $ hasTaintFlow=b
end

def m_dirname
  pn = Pathname.new(source 'a')
  sink pn.dirname # $ hasTaintFlow=a
end

def m_each_filename
  a = Pathname.new(source 'a')
  a.each_filename do |x|
    sink x # $ hasTaintFlow=a
  end
end

def m_expand_path
  a = Pathname.new(source 'a')
  sink a.expand_path() # $ hasTaintFlow=a
end

def m_join
  a = Pathname.new(source 'a')
  b = Pathname.new('foo')
  c = Pathname.new(source 'c')
  sink a.join(b, c) # $ hasTaintFlow=a $ hasTaintFlow=c
end

def m_parent
  a = Pathname.new(source 'a')
  sink a.parent() # $ hasTaintFlow=a
end

def m_realpath
  a = Pathname.new(source 'a')
  sink a.realpath() # $ hasTaintFlow=a
end

def m_relative_path_from
  a = Pathname.new(source 'a')
  sink a.relative_path_from('/foo/bar') # $ hasTaintFlow=a
end

def m_to_path
  a = Pathname.new(source 'a')
  sink a.to_path # $ hasTaintFlow=a
end

def m_to_s
  a = Pathname.new(source 'a')
  sink a.to_s # $ hasTaintFlow=a
end

def m_plus
  a = Pathname.new(source 'a')
  b = a + 'foo'
  sink b # $ hasTaintFlow=a
end

def m_slash
  a = Pathname.new(source 'a')
  b = a / 'foo'
  sink b # $ hasTaintFlow=a
end

def m_basename
  a = Pathname.new(source 'a')
  b = a.basename
  sink b # $ hasTaintFlow=a
end

def m_cleanpath
  a = Pathname.new(source 'a')
  b = a.cleanpath
  sink b # $ hasTaintFlow=a
end

def m_sub
  a = Pathname.new(source 'a')
  b = a.sub('foo', 'bar')
  sink b # $ hasTaintFlow=a
end

def m_sub_ext
  a = Pathname.new(source 'a')
  b = a.sub_ext('.txt')
  sink b # $ hasTaintFlow=a
end

# Test flow through intermediate pathnames
def intermediate_pathnames
  a = Pathname.new(source 'a')

  b = a + 'foo'
  sink b.realpath # $ hasTaintFlow=a

  c = a / 'foo'
  sink c.realpath # $ hasTaintFlow=a

  d = a.basename
  sink d.realpath # $ hasTaintFlow=a

  e = a.cleanpath
  sink e.realpath # $ hasTaintFlow=a

  f = a.expand_path
  sink f.realpath # $ hasTaintFlow=a

  g = a.join('foo')
  sink g.realpath # $ hasTaintFlow=a

  h = a.realpath
  sink h.realpath # $ hasTaintFlow=a

  i = a.relative_path_from('/foo/bar')
  sink i.realpath # $ hasTaintFlow=a

  j = a.sub('foo', 'bar')
  sink j.realpath # $ hasTaintFlow=a

  k = a.sub_ext('.txt')
  sink k.realpath # $ hasTaintFlow=a

  l = a.to_path
  sink l.realpath # $ hasTaintFlow=a
end