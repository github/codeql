import bottle
from bottle import Bottle, response, request

app = Bottle()
@app.route('/test', method=['OPTIONS', 'GET']) # $ routeSetup="/test"
def test1():  # $ requestHandler
    response.headers['Content-type'] = 'application/json' # $ headerWriteName='Content-type' headerWriteValue='application/json'
    response.set_header('Content-type', 'application/json') # $ headerWriteName='Content-type' headerWriteValue='application/json'
    return '[1]' # $ HttpResponse responseBody='[1]' mimetype=text/html

app.run()