from starlette.applications import Starlette
from starlette.middleware import Middleware
from starlette.middleware.cors import CORSMiddleware

routes = ...

middleware = [
    Middleware(CORSMiddleware, allow_origins=['*'], allow_credentials=True)  # $ CorsMiddleware=CORSMiddleware
]

app = Starlette(routes=routes, middleware=middleware)