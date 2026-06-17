class Foobar
  def foo1(target) # $ Source
    IO.popen("cat #{target}", "w") # $ Alert // NOT OK
  end

  def foo2(x)  # $ Source
    format = sprintf("cat %s", x) # $ Alert // NOT OK
    IO.popen(format, "w")
  end

  def fileRead1(path) 
    File.read(path) # OK
  end

  def my_exec(cmd, command, myCmd, myCommand, innocent_file_path)  # $ Source
    IO.popen("which #{cmd}", "w") # OK - the parameter is named `cmd`, so it's meant to be a command
    IO.popen("which #{command}", "w") # OK - the parameter is named `command`, so it's meant to be a command
    IO.popen("which #{myCmd}", "w") # OK - the parameter is named `myCmd`, so it's meant to be a command
    IO.popen("which #{myCommand}", "w") # OK - the parameter is named `myCommand`, so it's meant to be a command
    IO.popen("which #{innocent_file_path}", "w") # $ Alert // NOT OK - the parameter is named `innocent_file_path`, so it's not meant to be a command
  end

  def escaped(file_path) # $ Source
    IO.popen("cat #{file_path.shellescape}", "w") # OK - the parameter is escaped

    IO.popen("cat #{file_path}", "w") # $ Alert // NOT OK - the parameter is not escaped
  end
end

require File.join(File.dirname(__FILE__), 'sub', 'other')

class Foobar2
  def foo1(target) # $ Source
    IO.popen("cat #{target}", "w") # $ Alert // NOT OK
  end

  def id(x)  # $ Source
    IO.popen("cat #{x}", "w") # $ Alert // NOT OK - the parameter is not a constant.
    return x
  end
    
  def thisIsSafe()
    IO.popen("echo #{id('foo')}", "w") # OK - only using constants.
  end    

  # class methods
  def self.foo(target) # $ Source
    IO.popen("cat #{target}", "w") # $ Alert // NOT OK
  end

  def arrayJoin(x) # $ Source
    IO.popen(x.join(' '), "w") # $ Alert // NOT OK

    IO.popen(["foo", "bar", x].join(' '), "w") # $ Alert // NOT OK
  end

  def string_concat(x)  # $ Source
    IO.popen("cat " + x, "w") # $ Alert // NOT OK
  end

  def array_taint (x, y) # $ Source
    arr = ["cat"]
    arr.push(x)
    IO.popen(arr.join(' '), "w") # $ Alert // NOT OK

    arr2 = ["cat"]
    arr2 << y
    IO.popen(arr.join(' '), "w") # $ Alert // NOT OK
  end
end
