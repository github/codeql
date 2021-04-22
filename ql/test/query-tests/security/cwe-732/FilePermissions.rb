require "fileutils"

def run_chmod_1(filename)
  FileUtils.chmod 0222, filename
  FileUtils.chmod 0622, filename
  FileUtils.chmod 0755, filename
  FileUtils.chmod 0777, filename
end

module DummyModule
  def chmod(mode, list, options = {} )
    list
  end
end

def run_chmod_2(filename)
  foo = FileUtils
  bar = foo
  baz = Dummy
  # "safe"
  baz.chmod 0755, filename
  baz = bar
  # unsafe
  baz.chmod 0755, filename
end

def run_chmod_3(filename)
  # TODO: we currently miss this
  foo = FileUtils
  bar, baz = foo, 7
  bar.chmod 0755, filename
end

def run_chmod_4(filename)
  # safe permissions
  FileUtils.chmod 0700, filename
  FileUtils.chmod 0711, filename
  FileUtils.chmod 0701, filename
  FileUtils.chmod 0710, filename
end

def run_chmod_5(filename)
  perm = 0777
  FileUtils.chmod perm, filename
  perm2 = perm
  FileUtils.chmod perm2, filename

  perm = "u=wrx,g=rwx,o=x"
  perm2 = perm
  FileUtils.chmod perm2, filename
  FileUtils.chmod "u=rwx,o+r", filename
  FileUtils.chmod "u=rwx,go-r", filename
  FileUtils.chmod "a+rw", filename
end

def run_chmod_R(filename)
  File.chmod_R 0755, filename
end
