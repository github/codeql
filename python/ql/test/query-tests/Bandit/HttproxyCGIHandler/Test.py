import requests
import wsgiref.handlers

def application(environ, start_response):
    r = requests.get('https://192.168.0.42/private/api/foobar')
    start_response('200 OK', [('Content-Type', 'text/plain')])
    return [r.content]

if __name__ == '__main__':
    wsgiref.handlers.CGIHandler().run(application)
