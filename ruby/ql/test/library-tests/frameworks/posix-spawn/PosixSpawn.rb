POSIX::Spawn::popen4("ls", "-l")
POSIX::Spawn.popen4("ls", "-l")

POSIX::Spawn::Child.new({'ENV' => @var}, "foo/"+cmd, *argv, :chdir=>root_dir)
POSIX::Spawn::Child.new(*command, input: options[:stdin].to_s, timeout: timeout)

POSIX::Spawn.spawn(*(argv+[{:in => f}]))
POSIX::Spawn::spawn('sleep 5')
POSIX::Spawn.spawn(cmd)
POSIX::Spawn.spawn(env, "ls")

POSIX::Spawn::Child.new("ls", "-l")
POSIX::Spawn::Child.build("echo", msg)

POSIX::Spawn.system("foo", "bar", "--a-flag", before, after)

POSIX::Spawn.fspawn(command)
POSIX::Spawn.pspawn(command)
POSIX::Spawn.popen4(command)

POSIX::Spawn.`("foo", "bar")
