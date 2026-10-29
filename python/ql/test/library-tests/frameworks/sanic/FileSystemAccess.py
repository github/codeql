from sanic import response

response.file("file")  # $ getAPathArgument="file"
response.file_stream("file")  # $ getAPathArgument="file"
