eval("raise \"error\"", binding, "file", 1)
send("raise", "error")

a = []
a.send("push", "1")

class Foo
  def eval(x)
    x + 1
  end

  def send(*args)
    2
  end

  def run
    eval("exit 1")
  end
end

Foo.new.send("exit", 1)

system("echo foo")
system("echo", "foo")
system(["echo", "echo"], "foo")

system({"FOO" => "BAR"}, "echo foo")
system({"FOO" => "BAR"}, "echo", "foo")
system({"FOO" => "BAR"}, ["echo", "echo"], "foo")

system("echo foo", unsetenv_others: true)
system("echo", "foo", unsetenv_others: true)
system(["echo", "echo"], "foo", unsetenv_others: true)

system({"FOO" => "BAR"}, "echo foo", unsetenv_others: true)
system({"FOO" => "BAR"}, "echo", "foo", unsetenv_others: true)
system({"FOO" => "BAR"}, ["echo", "echo"], "foo", unsetenv_others: true)

exec("echo foo")
exec("echo", "foo")
exec(["echo", "echo"], "foo")

exec({"FOO" => "BAR"}, "echo foo")
exec({"FOO" => "BAR"}, "echo", "foo")
exec({"FOO" => "BAR"}, ["echo", "echo"], "foo")

exec("echo foo", unsetenv_others: true)
exec("echo", "foo", unsetenv_others: true)
exec(["echo", "echo"], "foo", unsetenv_others: true)

exec({"FOO" => "BAR"}, "echo foo", unsetenv_others: true)
exec({"FOO" => "BAR"}, "echo", "foo", unsetenv_others: true)
exec({"FOO" => "BAR"}, ["echo", "echo"], "foo", unsetenv_others: true)

spawn("echo foo")
spawn("echo", "foo")
spawn(["echo", "echo"], "foo")

spawn({"FOO" => "BAR"}, "echo foo")
spawn({"FOO" => "BAR"}, "echo", "foo")
spawn({"FOO" => "BAR"}, ["echo", "echo"], "foo")

spawn("echo foo", unsetenv_others: true)
spawn("echo", "foo", unsetenv_others: true)
spawn(["echo", "echo"], "foo", unsetenv_others: true)

spawn({"FOO" => "BAR"}, "echo foo", unsetenv_others: true)
spawn({"FOO" => "BAR"}, "echo", "foo", unsetenv_others: true)
spawn({"FOO" => "BAR"}, ["echo", "echo"], "foo", unsetenv_others: true)

module MockSystem
  def system(*args)
    args
  end

  def self.system(*args)
    args
  end
end

class Foo
  include MockSystem

  def run
    system("ls")
    MockSystem.system("ls")
  end
end

UnknownModule.system("ls")