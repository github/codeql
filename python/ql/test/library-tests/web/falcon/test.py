import json

from falcon import API

app = API()

class Handler(object):

    def on_get(self, req, resp):
        raw_json = req.stream.read()
        result = json.loads(raw_json)
        resp.status = 200
        result = {
            'status': 'success',
            'data': result
        }
        resp.body = json.dumps(result)

    def on_post(self, req, resp):
        pass

app.add_route('/hello', Handler())

