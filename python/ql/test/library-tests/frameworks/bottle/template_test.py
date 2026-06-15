import bottle
from bottle import response, request, template, SimpleTemplate 

app = bottle.app()
@app.route('/test', method=['OPTIONS', 'GET']) # $ routeSetup="/test"
def test1():   # $ requestHandler
    template("abc") # $ templateConstruction="abc"
    SimpleTemplate("abc") # $ templateConstruction="abc"
    return '[1]' # $ HttpResponse mimetype=text/html responseBody='[1]' 