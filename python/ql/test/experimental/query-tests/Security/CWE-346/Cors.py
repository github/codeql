import cherrypy

def bad():
    request = cherrypy.request
    validCors = "domain.com"
    if request.method in ['POST', 'PUT', 'PATCH', 'DELETE']:
        origin = request.headers.get('Origin', None)
        if origin.startswith(validCors):
            print("Origin Valid")

def good():
    request = cherrypy.request
    validOrigin = "domain.com"
    if request.method in ['POST', 'PUT', 'PATCH', 'DELETE']:
        origin = request.headers.get('Origin', None)
        if origin == validOrigin:
            print("Origin Valid")