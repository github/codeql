`echo foo`
%x(echo foo)
%x{echo foo}
%x[echo foo]
%x/echo foo/

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

Open3.popen3("echo foo")
Open3.popen2("echo foo")
Open3.popen2e("echo foo")
Open3.capture3("echo foo")
Open3.capture2("echo foo")
Open3.capture2e("echo foo")
Open3.pipeline_rw("echo foo", "grep bar")
Open3.pipeline_r("echo foo", "grep bar")
Open3.pipeline_w("echo foo", "grep bar")
Open3.pipeline_start("echo foo", "grep bar")
Open3.pipeline("echo foo", "grep bar")

<<`EOF`
echo foo
EOF

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
