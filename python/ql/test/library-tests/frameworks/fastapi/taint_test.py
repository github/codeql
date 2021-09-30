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


@app.post("/test_taint/{name}/{number}") # $ routeSetup="/test_taint/{name}/{number}"
async def test_taint(name : str, number : int, also_input: MyComplexModel): # $ requestHandler routedParameter=name routedParameter=number routedParameter=also_input
    ensure_tainted(
        name, # $ tainted
        number, # $ tainted

        also_input, # $ tainted
        also_input.field, # $ MISSING: tainted

        also_input.main_foo, # $ MISSING: tainted
        also_input.main_foo.foo, # $ MISSING: tainted

        also_input.other_foos, # $ MISSING: tainted
        also_input.other_foos[0], # $ MISSING: tainted
        also_input.other_foos[0].foo, # $ MISSING: tainted
        [f.foo for f in also_input.other_foos], # $ MISSING: tainted
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
