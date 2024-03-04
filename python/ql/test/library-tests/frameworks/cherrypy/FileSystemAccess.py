import cherrypy
from cherrypy.lib.static import serve_file, serve_download, staticfile

serve_file("file")  # $ getAPathArgument="file"
serve_download("file")  # $ getAPathArgument="file"
staticfile("file")  # $ getAPathArgument="file"
# root won't make this safe
staticfile("file", root="/path/to/safe/dir") # $ getAPathArgument="file"
