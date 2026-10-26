
foo_path = Pathname.new "foo.txt"
foo_path2 = foo_path
foo_path

bar_path = Pathname.new 'bar'

# All these calls return new `Pathname` instances
pwd1 = Pathname.getwd
p00 = pwd1 + foo_path
p01 = pwd1 / bar_path
p02 = pwd1.basename
p03 = Pathname.new('bar/../baz.txt').cleanpath
p04 = foo_path.expand_path
p05 = pwd1.join 'bar', 'baz', 'qux.txt'
p06 = foo_path.realpath
p07 = Pathname.new('foo/bar.txt').relative_path_from('foo')
p08 = pwd1.sub 'wibble', 'wobble'
p09 = foo_path.sub_ext '.log'
p10 = foo_path.to_path

# `Pathname#to_s` returns a string that we consider to be a filename source.
foo_string = foo_path.to_s

# File-system accesses
foo_file = foo_path.open
foo_file.close
pwd_dir = pwd1.opendir
pwd_dir.close

# Read from a file
foo_data = foo_path.read

# Write to a file
foo_path.write 'output'

# Permission modifications
foo_path.chmod 0644
foo_file = foo_path.open 'w', 0666
foo_file.close
p08.mkdir 0755
p01.mkpath(mode: 0644)
