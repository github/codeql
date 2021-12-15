
import random
import string

import cherrypy

class A(object):

    @cherrypy.expose
    def a(self, arg):
        return "hello " + arg

class B(object):

    @cherrypy.expose
    def b(self, arg):
        return "bye " + arg

cherrypy.tree.mount(A(), '/a', a_conf)
cherrypy.tree.mount(B(), '/b', b_conf)

cherrypy.engine.start()
cherrypy.engine.block()