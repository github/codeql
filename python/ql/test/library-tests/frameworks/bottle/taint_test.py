import bottle
from bottle import response, request


app = bottle.app()
@app.route('/test', method=['OPTIONS', 'GET']) # $ routeSetup="/test"
def test1():   # $ requestHandler

    ensure_tainted(
        request.headers,  # $ tainted
        request.headers,  # $ tainted
        request.forms,  # $ tainted
        request.params, # $ tainted
        request.url,  # $ tainted
        request.body, # $ tainted
        request.fullpath, # $ tainted
        request.query_string # $ tainted
    )
    return '[1]' # $ HttpResponse mimetype=text/html responseBody='[1]'

app.run()