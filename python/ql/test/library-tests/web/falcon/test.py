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

    # TODO: does this return do anything?
    def on_delete(self, req, resp):
        env = req.env
        qs = env["QUERY_STRING"]
        return qs

app.add_route('/hello', Handler())

# From https://falcon.readthedocs.io/en/2.0.0/
class QuoteResource(object):

    def on_get(self, req, resp):
        """Handles GET requests"""
        quote = {
            'quote': (
                "I've always been more interested in "
                "the future than in the past."
            ),
            'author': 'Grace Hopper'
        }

        resp.media = quote

api.add_route('/quote', QuoteResource())

# From https://falcon.readthedocs.io/en/2.0.0/user/quickstart.html
class ThingsResource(object):

    def on_get(self, req, resp, user_id):

        result = [{'foo': 42, 'bar': 43, 'user_id': user_id}]

        # NOTE: Starting with Falcon 1.3, you can simply
        # use resp.media for this instead.
        resp.context.result = result

        resp.set_header('Powered-By', 'Falcon')
        resp.status = falcon.HTTP_200

app.add_route('/{user_id}/things', things)
