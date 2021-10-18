#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：ip address spoofing
"""
import tornado.httpserver
import tornado.options
import tornado.web
import tornado.ioloop

from tornado.options import define, options

define("port", default=8000, help="run on the given port,default 8000", type=int)


class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        client_ip = self.request.headers.get('x-forwarded-for')
        if client_ip:
            client_ip = client_ip.split(',')[len(client_ip.split(',')) - 1]
        else:
            client_ip = self.request.headers.get('REMOTE_ADDR', None)
        if not client_ip == '127.0.0.1':
            raise Exception('ip illegal')
        self.write("hello.")

handlers = [(r"/", IndexHandler)]

if __name__ == "__main__":
    tornado.options.parse_command_line()
    app = tornado.web.Application(
        handlers
    )
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
