
import tornado.web

class Handler1(tornado.web.RequestHandler):
    def get(self):
        self.write(self.get_argument("xss"))

class Handler2(tornado.web.RequestHandler):
    def get(self):
        args = self.get_body_arguments()
        name = args[0]
        self.write(name)

class Handler3(tornado.web.RequestHandler):

    def get(self):
        req = self.request
        h = req.headers
        url = h["url"]
        self.redirect(url)


class DeepInheritance(Handler3):

    def get(self):
        self.write(self.get_argument("also_xss"))
