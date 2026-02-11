# Source: https://bottlepy.org/docs/dev/tutorial.html#the-application-object
from bottle import Bottle, run

app = Bottle()

@app.route('/hello') # $ routeSetup="/hello"
def hello(): # $ requestHandler
    return "Hello World!" # $ HttpResponse responseBody="Hello World!" mimetype=text/html

if __name__ == '__main__':
    app.run(host='localhost', port=8080)