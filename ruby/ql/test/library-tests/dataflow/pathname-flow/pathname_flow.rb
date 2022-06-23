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