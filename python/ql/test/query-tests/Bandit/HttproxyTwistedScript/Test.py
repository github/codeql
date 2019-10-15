from twisted.internet import reactor
from twisted.web import static, server, twcgi

root = static.File("/root")
root.putChild("login.cgi", twcgi.CGIScript("/var/www/cgi-bin/login.py"))
reactor.listenTCP(80, server.Site(root))
reactor.run()
