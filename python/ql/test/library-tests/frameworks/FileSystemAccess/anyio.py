import anyio
from anyio.streams.file import FileReadStream, FileWriteStream
from anyio import Path

anyio.open_file("file", 'r') # $ getAPathArgument="file"
FileReadStream.from_path("file") # $ getAPathArgument="file"
FileWriteStream.from_path("file") # $ getAPathArgument="file"
Path("file") # $ getAPathArgument="file"
