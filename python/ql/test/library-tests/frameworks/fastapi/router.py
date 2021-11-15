# like blueprints in Flask
# see https://fastapi.tiangolo.com/tutorial/bigger-applications/

from fastapi import APIRouter, FastAPI


inner_router = APIRouter()

@inner_router.get("/foo") # $ routeSetup="/foo"
async def root(): # $ requestHandler
    return {"msg": "inner_router /foo"} # $ HttpResponse

outer_router = APIRouter()
outer_router.include_router(inner_router, prefix="/inner")


items_router = APIRouter(
    prefix="/items",
    tags=["items"],
)


@items_router.get("/") # $ routeSetup="/"
async def items(): # $ requestHandler
    return {"msg": "items_router /"} # $ HttpResponse


app = FastAPI()

app.include_router(outer_router, prefix="/outer")
app.include_router(items_router)

# see basic.py for instructions for how to run this code.
