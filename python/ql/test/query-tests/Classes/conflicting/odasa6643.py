#This code has conflicting attributes,
#but the documentation in the standard library tells you do it this way :(

class ThreadingMixIn(object):

    def process_request(selfself, req):
        pass

class HTTPServer(object):

    def process_request(selfself, req):
        pass

class _ThreadingSimpleServer(ThreadingMixIn, HTTPServer):
    pass
