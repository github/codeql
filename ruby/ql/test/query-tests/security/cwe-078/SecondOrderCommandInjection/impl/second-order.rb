class Foobar
  def secondOrderOne(remote)
    list = ["clone", remote]
    # git clone remote
    Open3.capture3("git", *list)
  end

  def foo(remote) 
    list = ["clone", remote]
    indirect(list)
  end
end

def indirect(list) 
  Open3.capture3("git", *list)
end