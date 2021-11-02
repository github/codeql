# Uses of eval and send

eval("raise \"error\"")
send("raise", "error")

a = []
a.send("raise", "error")

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
