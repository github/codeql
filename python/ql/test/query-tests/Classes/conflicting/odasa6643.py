#This code has conflicting attributes,
#but the documentation in the standard library tells you do it this way :(

#See https://discuss.lgtm.com/t/warning-on-normal-use-of-python-socketserver-mixins/677

class ThreadingMixIn(object):

    def process_request(selfself, req):
        pass

class HTTPServer(object):

    def process_request(selfself, req):
        pass

class _ThreadingSimpleServer(ThreadingMixIn, HTTPServer):
    pass
