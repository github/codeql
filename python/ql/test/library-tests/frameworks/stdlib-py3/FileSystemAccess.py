from pathlib import Path, PosixPath, WindowsPath

p = Path("filepath")
posix = PosixPath("posix/filepath")
windows = WindowsPath("windows/filepath")

p.chmod(0o777)  # $ getAPathArgument=p
posix.chmod(0o777)  # $ getAPathArgument=posix
windows.chmod(0o777)  # $ getAPathArgument=windows

with p.open() as f:  # $ getAPathArgument=p
    f.read()

p.write_bytes(b"hello")  # $ getAPathArgument=p fileWriteData=b"hello"
p.write_text("hello")  # $ getAPathArgument=p fileWriteData="hello"
p.open("wt").write("hello")  # $ getAPathArgument=p fileWriteData="hello"

name = windows.parent.name
o = open
o(name)  # $ getAPathArgument=name

wb = p.write_bytes
wb(b"hello")  # $ getAPathArgument=p fileWriteData=b"hello"

p.link_to("target") # $ getAPathArgument=p getAPathArgument="target"
p.link_to(target="target") # $ getAPathArgument=p getAPathArgument="target"

p.samefile("other_path") # $ getAPathArgument=p getAPathArgument="other_path"
p.samefile(other_path="other_path") # $ getAPathArgument=p getAPathArgument="other_path"

p.rename("target") # $ getAPathArgument=p getAPathArgument="target"
p.rename(target="target") # $ getAPathArgument=p getAPathArgument="target"

p.replace("target") # $ getAPathArgument=p getAPathArgument="target"
p.replace(target="target") # $ getAPathArgument=p getAPathArgument="target"
