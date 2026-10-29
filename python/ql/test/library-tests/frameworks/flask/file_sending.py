from flask import send_from_directory, send_file

send_from_directory("dir", "file")  # $ getAPathArgument="dir" getAPathArgument="file"
send_from_directory(directory="dir", filename="file") # $ getAPathArgument="dir" getAPathArgument="file"

send_file("file")  # $ getAPathArgument="file"
send_file(filename_or_fp="file")  # $ getAPathArgument="file"
