# --- to make things runable ---

ensure_tainted = ensure_not_tainted = print

# --- real code ---

from fastapi import FastAPI
from typing import Optional, List
from pydantic import BaseModel


app = FastAPI()


class Foo(BaseModel):
    foo: str


class MyComplexModel(BaseModel):
    field: str
    main_foo: Foo
    other_foos: List[Foo]
    nested_foos: List[List[Foo]]


@app.post("/test_taint/{name}/{number}") # $ routeSetup="/test_taint/{name}/{number}"
async def test_taint(name : str, number : int, also_input: MyComplexModel): # $ requestHandler routedParameter=name routedParameter=number routedParameter=also_input
    ensure_tainted(
        name, # $ tainted
        number, # $ tainted

        also_input, # $ tainted
        also_input.field, # $ tainted

        also_input.main_foo, # $ tainted
        also_input.main_foo.foo, # $ tainted

        also_input.other_foos, # $ tainted
        also_input.other_foos[0], # $ tainted
        also_input.other_foos[0].foo, # $ tainted
        [f.foo for f in also_input.other_foos], # $ MISSING: tainted

        also_input.nested_foos, # $ tainted
        also_input.nested_foos[0], # $ tainted
        also_input.nested_foos[0][0], # $ tainted
        also_input.nested_foos[0][0].foo, # $ tainted
    )

    other_foos = also_input.other_foos

    ensure_tainted(
        other_foos, # $ tainted
        other_foos[0], # $ tainted
        other_foos[0].foo, # $ tainted
        [f.foo for f in other_foos], # $ MISSING: tainted
    )

    return "ok" # $ HttpResponse


# --- body ---
# see https://fastapi.tiangolo.com/tutorial/body-multiple-params/

from fastapi import Body

# request is made such as `/will-be-query-param?name=foo`
@app.post("/will-be-query-param") # $ routeSetup="/will-be-query-param"
async def will_be_query_param(name: str): # $ requestHandler routedParameter=name
    ensure_tainted(name) # $ tainted
    return "ok" # $ HttpResponse

# with the `= Body(...)` "annotation" FastAPI will know to transmit `name` as part of
# the HTTP post body
@app.post("/will-not-be-query-param") # $ routeSetup="/will-not-be-query-param"
async def will_not_be_query_param(name: str = Body("foo", media_type="text/plain")): # $ requestHandler routedParameter=name
    ensure_tainted(name) # $ tainted
    return "ok" # $ HttpResponse


# --- form data ---
# see https://fastapi.tiangolo.com/tutorial/request-forms/

from fastapi import Form

@app.post("/form-example") # $ routeSetup="/form-example"
async def form_example(username: str = Form(None)): # $ requestHandler routedParameter=username
    ensure_tainted(username) # $ tainted
    return "ok" # $ HttpResponse


# --- HTTP headers ---
# see https://fastapi.tiangolo.com/tutorial/header-params/

from fastapi import Header

@app.get("/header-example") # $ routeSetup="/header-example"
async def header_example(user_agent: Optional[str] = Header(None)): # $ requestHandler routedParameter=user_agent
    ensure_tainted(user_agent) # $ tainted
    return "ok" # $ HttpResponse


# --- file upload ---
# see https://fastapi.tiangolo.com/tutorial/request-files/
# see https://fastapi.tiangolo.com/tutorial/request-files/#uploadfile

from fastapi import File, UploadFile

@app.post("/file-upload") # $ routeSetup="/file-upload"
async def file_upload(f1: bytes = File(None), f2: UploadFile = File(None)): # $ requestHandler routedParameter=f1 routedParameter=f2
    ensure_tainted(
        f1, # $ tainted

        f2, # $ tainted
        f2.filename, # $ MISSING: tainted
        f2.content_type, # $ MISSING: tainted
        f2.file, # $ MISSING: tainted
        f2.file.read(), # $ MISSING: tainted
        f2.file.readline(), # $ MISSING: tainted
        f2.file.readlines(), # $ MISSING: tainted
        await f2.read(), # $ MISSING: tainted
    )
    return "ok" # $ HttpResponse

# --- WebSocket ---

import starlette.websockets
from fastapi import WebSocket


assert WebSocket == starlette.websockets.WebSocket


@app.websocket("/ws") # $ routeSetup="/ws"
async def websocket_test(websocket: WebSocket): # $ requestHandler routedParameter=websocket
    await websocket.accept()

    ensure_tainted(
        websocket, # $ tainted

        websocket.url, # $ tainted

        websocket.url.netloc, # $ tainted
        websocket.url.path, # $ tainted
        websocket.url.query, # $ tainted
        websocket.url.fragment, # $ tainted
        websocket.url.username, # $ tainted
        websocket.url.password, # $ tainted
        websocket.url.hostname, # $ tainted
        websocket.url.port, # $ tainted

        websocket.url.components, # $ tainted
        websocket.url.components.netloc, # $ tainted
        websocket.url.components.path, # $ tainted
        websocket.url.components.query, # $ tainted
        websocket.url.components.fragment, # $ tainted
        websocket.url.components.username, # $ tainted
        websocket.url.components.password, # $ tainted
        websocket.url.components.hostname, # $ tainted
        websocket.url.components.port, # $ tainted

        websocket.headers, # $ tainted
        websocket.headers["key"], # $ tainted

        websocket.query_params, # $ tainted
        websocket.query_params["key"], # $ tainted

        websocket.cookies, # $ tainted
        websocket.cookies["key"], # $ tainted

        await websocket.receive(), # $ tainted
        await websocket.receive_bytes(), # $ tainted
        await websocket.receive_text(), # $ tainted
        await websocket.receive_json(), # $ tainted
    )

    # scheme seems very unlikely to give interesting results, but very likely to give FPs.
    ensure_not_tainted(
        websocket.url.scheme,
        websocket.url.components.scheme,
    )

    async for data in  websocket.iter_bytes():
        ensure_tainted(data) # $ tainted

    async for data in  websocket.iter_text():
        ensure_tainted(data) # $ tainted

    async for data in  websocket.iter_json():
        ensure_tainted(data) # $ tainted
