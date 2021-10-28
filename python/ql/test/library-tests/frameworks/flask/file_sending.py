from flask import send_from_directory, send_file

send_from_directory("filepath", "file")  # $ getAPathArgument="filepath" getAPathArgument="file"
send_from_directory(directory="filepath", filename="file") # $ getAPathArgument="filepath" getAPathArgument="file"

send_file("file")  # $ getAPathArgument="file"
send_file(filename_or_fp="file")  # $ getAPathArgument="file"
