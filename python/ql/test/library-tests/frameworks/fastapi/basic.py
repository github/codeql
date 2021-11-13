# Taking inspiration from https://realpython.com/fastapi-python-web-apis/

# run with
# uvicorn basic:app --reload
# Then visit http://127.0.0.1:8000/docs and http://127.0.0.1:8000/redoc

from fastapi import FastAPI

app = FastAPI()

@app.get("/") # $ routeSetup="/"
async def root(): # $ requestHandler
    return {"message": "Hello World"} # $ HttpResponse

@app.get("/non-async") # $ routeSetup="/non-async"
def non_async(): # $ requestHandler
    return {"message": "non-async"} # $ HttpResponse

@app.get(path="/kw-arg") # $ routeSetup="/kw-arg"
def kw_arg(): # $ requestHandler
    return {"message": "kw arg"} # $ HttpResponse

@app.get("/foo/{foo_id}") # $ routeSetup="/foo/{foo_id}"
async def get_foo(foo_id: int): # $ requestHandler routedParameter=foo_id
    # FastAPI does data validation (with `pydantic` PyPI package) under the hood based
    # on the type annotation we did for `foo_id`, so it will auto-reject anything that's
    # not an int.
    return {"foo_id": foo_id} # $ HttpResponse

# this will work as query param, so `/bar?bar_id=123`
@app.get("/bar") # $ routeSetup="/bar"
async def get_bar(bar_id: int = 42): # $ requestHandler routedParameter=bar_id
    return {"bar_id": bar_id} # $ HttpResponse

# The big deal is that FastAPI works so well together with pydantic, so you can do stuff like this
from typing import Optional
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    price: float
    is_offer: Optional[bool] = None

@app.post("/items/") # $ routeSetup="/items/"
async def create_item(item: Item): # $ requestHandler routedParameter=item
    # Note: calling `item` a routed parameter is slightly untrue, since it doesn't come
    # from the URL itself, but from the body of the POST request
    return item # $ HttpResponse

# this also works fine
@app.post("/2items") # $ routeSetup="/2items"
async def create_item2(item1: Item, item2: Item): # $ requestHandler routedParameter=item1 routedParameter=item2
    return (item1, item2) # $ HttpResponse

@app.api_route("/baz/{baz_id}", methods=["GET"]) # $ routeSetup="/baz/{baz_id}"
async def get_baz(baz_id: int): # $ requestHandler routedParameter=baz_id
    return {"baz_id2": baz_id} # $ HttpResponse

# Docs:
# see https://fastapi.tiangolo.com/tutorial/path-params/

# Things we should look at supporting:
# - https://fastapi.tiangolo.com/tutorial/dependencies/
# - https://fastapi.tiangolo.com/tutorial/background-tasks/
# - https://fastapi.tiangolo.com/tutorial/middleware/
# - https://fastapi.tiangolo.com/tutorial/encoder/
