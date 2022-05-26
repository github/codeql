# `foo_file` is a `File` instance
foo_file = File.new("foo.txt", "a+")
foo_file_2 = foo_file
foo_file

# File read access
foo_lines = foo_file_2.readlines

# `fp` is a file path
fp = foo_file.path
fp = foo_file.to_path

# `FileUtils.makedirs` returns an array of file names
dirs = FileUtils.makedirs(["dir1", "dir2"])

# `rand` is an `IO` instance
rand = IO.new(IO.sysopen("/dev/random", "r"), "r")
rand_2 = rand

rand_data = rand.read(32)

# `foo_file_kernel` is a `File` instance
foo_file_kernel = open("foo.txt")
foo_file_kernel = Kernel.open("foo.txt")

foo_command_kernel = open("|ls")

# `IO.read("foo.txt")` reads from a file
foo_text = IO.read("foo.txt")

# `IO.read("|date")` does not read from a file
date = IO.read("|date")

# `rand_open` is an `IO` instance
rand_open = IO.open(IO.sysopen("/dev/random", "r"), "r")

foo_file_3 = File.open("foo.txt")

# File write accesses
foo_file.puts("hello")
File.open("foo.txt", "a+").write("world\n")

# IO instance
io_file = IO.open(IO.sysopen("foo.txt", "w"))
str_1 = "hello"
int_1 = 123
# File/IO write
io_file.printf("%s: %d\n", str_1, int_1)
