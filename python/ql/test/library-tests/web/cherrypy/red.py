
import cherrypy

class MultiPath(object):

    @cherrypy.expose(['color', 'colour'])
    def red(self):
        return "RED"

if __name__ == '__main__':
    cherrypy.quickstart(MultiPath())
