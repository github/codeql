
class TCPServer(object):
    
    def process_request(self, request, client_address):
        self.do_work(request, client_address)
        self.shutdown_request(request)

    
class ThreadingMixIn:
    """Mix-in class to handle each request in a new thread."""

    def process_request(self, request, client_address):
        """Start a new thread to process the request."""
        t = threading.Thread(target = self.do_work, args = (request, client_address))
        t.daemon = self.daemon_threads
        t.start()

class ThreadingTCPServer(ThreadingMixIn, TCPServer): pass
