import httplib
c = httplib.HTTPSConnection("example.com")

import http.client
c = http.client.HTTPSConnection("example.com")

import six
six.moves.http_client.HTTPSConnection("example.com")
