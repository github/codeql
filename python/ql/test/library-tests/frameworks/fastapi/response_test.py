# see https://fastapi.tiangolo.com/advanced/response-cookies/

from fastapi import FastAPI, Response


app = FastAPI()


@app.get("/response_parameter") # $ routeSetup="/response_parameter"
async def response_parameter(response: Response): # $ requestHandler
    response.set_cookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value"
    response.set_cookie(key="key", value="value") # $ CookieWrite CookieName="key" CookieValue="value"
    response.headers.append("Set-Cookie", "key2=value2") # $ CookieWrite CookieRawHeader="key2=value2"
    response.headers.append(key="Set-Cookie", value="key2=value2") # $ CookieWrite CookieRawHeader="key2=value2"
    response.headers["X-MyHeader"] = "header-value"
    response.status_code = 418
    return {"message": "response as parameter"} # $ HttpResponse mimetype=application/json responseBody=Dict


@app.get("/resp_parameter") # $ routeSetup="/resp_parameter"
async def resp_parameter(resp: Response): # $ requestHandler
    resp.status_code = 418
    return {"message": "resp as parameter"} # $ HttpResponse mimetype=application/json responseBody=Dict


@app.get("/response_parameter_no_type") # $ routeSetup="/response_parameter_no_type"
async def response_parameter_no_type(response): # $ requestHandler routedParameter=response
    # NOTE: This does in fact not work, since FastAPI relies on the type annotations,
    # and not on the name of the parameter
    response.status_code = 418
    return {"message": "response as parameter"} # $ HttpResponse mimetype=application/json responseBody=Dict


# Direct response

# see https://fastapi.tiangolo.com/advanced/response-directly/

# TODO
