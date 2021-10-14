# Uses of eval and send

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
Foo.new.instance_eval("self.class", "file.rb", 3)
Foo.class_eval("def foo; 1; end", "file.rb", 1)
Foo.module_eval("def bar; 1; end", "other_file.rb", 2)