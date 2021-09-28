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
