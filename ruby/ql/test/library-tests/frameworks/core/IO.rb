IO.popen("cat foo.txt | tail")
IO.popen({some_env_var: "123"}, "cat foo.txt | tail")
IO.popen({some_env_var: "123"}, "cat foo.txt | tail", {some: :opt})

IO.popen(["cat", "foo.txt"])
IO.popen([{some_env_var: "123"}, "cat", "foo.txt"])
IO.popen([{some_env_var: "123"}, "cat", "foo.txt"], {some: :opt})

IO.popen([["cat", "argv0"], "foo.txt"])
IO.popen([{some_env_var: "123"}, ["cat", "argv0"], "foo.txt"])
IO.popen([{some_env_var: "123"}, ["cat", "argv0"], "foo.txt"], {some: :opt})
IO.popen({some_env_var: "123"}, [["cat", "argv0"], "foo.txt"], {some: :opt})

IO.popen("-")
IO.popen({some_env_var: "123"}, "-")
IO.popen({some_env_var: "123"}, "-", {some: :opt})

cmd = "cat foo.txt | tail"
IO.popen(cmd)
IO.popen({some_env_var: "123"}, cmd)
IO.popen({some_env_var: "123"}, cmd, {some: :opt})

cmd = ["cat", "foo.txt"]
IO.popen(cmd)
IO.popen({some_env_var: "123"}, cmd)
IO.popen({some_env_var: "123"}, cmd, {some: :opt})

cmd = [["cat", "argv0"], "foo.txt"]
IO.popen(cmd)
IO.popen({some_env_var: "123"}, cmd)
IO.popen({some_env_var: "123"}, cmd, {some: :opt})

def popen(cmd)
  IO.popen(cmd)
end

popen("cat foo.txt | tail")
popen(["cat", "foo.txt"])