require "fileutils"

def run_chmod_1(filename)
  # BAD: sets file as world writable
  FileUtils.chmod 0222, filename
  # BAD: sets file as world writable
  FileUtils.chmod 0622, filename
  # BAD: sets file as world readable
  FileUtils.chmod 0755, filename
  # BAD: sets file as world readable + writable
  FileUtils.chmod 0777, filename
end

module DummyModule
  def chmod(mode, list, options = {} )
    list
  end
end

def run_chmod_2(filename)
  foo = File
  bar = foo
  baz = DummyModule
  # GOOD: DummyModule is not a known class that performs file permission modifications
  baz.chmod 0755, filename
  baz = bar
  # BAD: sets file as world readable
  baz.chmod 0755, filename
end

def run_chmod_3(filename)
  # TODO: we currently miss this
  foo = FileUtils
  bar, baz = foo, 7
  # BAD: sets file as world readable
  bar.chmod 0755, filename
end

def run_chmod_4(filename)
  # GOOD: no group/world access
  FileUtils.chmod 0700, filename
  # GOOD: group/world execute bit only
  FileUtils.chmod 0711, filename
  # GOOD: world execute bit only
  FileUtils.chmod 0701, filename
  # GOOD: group execute bit only
  FileUtils.chmod 0710, filename
end

def run_chmod_5(filename)
  perm = 0777
  # BAD: sets world rwx
  FileUtils.chmod perm, filename
  perm2 = perm
  # BAD: sets world rwx
  FileUtils.chmod perm2, filename

  perm = "u=wrx,g=rwx,o=x"
  perm2 = perm
  # BAD: sets group rwx
  FileUtils.chmod perm2, filename
  # BAD: sets file as world readable
  FileUtils.chmod "u=rwx,o+r", filename
  # GOOD: sets file as group/world unreadable
  FileUtils.chmod "u=rwx,go-r", filename
  # BAD: sets group/world as +rw
  FileUtils.chmod "a+rw", filename
end

def run_chmod_R(filename)
  # BAD: sets file as world readable
  FileUtils.chmod_R 0755, filename
end
