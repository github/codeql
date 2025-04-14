import cherrypy

def good():
    request = cherrypy.request
    validOrigin = "domain.com"
    if request.method in ['POST', 'PUT', 'PATCH', 'DELETE']:
        origin = request.headers.get('Origin', None)
        if origin == validOrigin:
            print("Origin Valid")