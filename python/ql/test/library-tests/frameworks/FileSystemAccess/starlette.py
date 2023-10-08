from starlette.responses import FileResponse
from baize.asgi import FileResponse as baizeFileResponse

baizeFileResponse("file")  # $ getAPathArgument="file"
FileResponse("file")  # $ getAPathArgument="file"
