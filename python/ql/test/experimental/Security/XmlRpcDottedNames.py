# Copied from official python 3 documentation, at https://docs.python.org/3/library/xmlrpc.server.html#xmlrpc.server.SimpleXMLRPCServer

import sys, datetime
from xmlrpc.server import SimpleXMLRPCServer

class ExampleService:
    def getData(self):
        return '42'

    class currentTime:
        @staticmethod
        def getCurrentTime():
            return datetime.datetime.now()

with SimpleXMLRPCServer(("localhost", 8000)) as server:
    server.register_function(pow)
    server.register_function(lambda x,y: x+y, 'add')
    # WARNING: Only set the allow_dotted_names flag to true within a secure, closed network.
    server.register_instance(ExampleService(), allow_dotted_names=True)
    server.register_multicall_functions()
    print('Serving XML-RPC on localhost port 8000')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nKeyboard interrupt received, exiting.")
        sys.exit(0)