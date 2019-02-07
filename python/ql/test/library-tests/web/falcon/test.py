

from falcon import API

app = API()

class Handler(object):

    def on_get(self, req, resp):
        ...

    def on_post(self, req, resp):
        ...

app.add_route('/hello', Handler())

