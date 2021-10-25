   
#Fixed by overriding. This does not change behavior, but makes it explicit and comprehensible.
class ThreadingTCPServerOverriding(ThreadingMixIn, TCPServer):
    
    def process_request(self, request, client_address):
        #process_request forwards to do_work, so it is OK to call ThreadingMixIn.process_request directly
        ThreadingMixIn.process_request(self, request, client_address)
        

#Fixed by separating threading functionality from request handling.
class ThreadingMixIn:
    """Mix-in class to help with threads."""

    def do_job_in_thread(self, job, args):
        """Start a new thread to do the job"""
        t = threading.Thread(target = job, args = args)
        t.start()

class ThreadingTCPServerChangedHierarchy(ThreadingMixIn, TCPServer):
    
    def process_request(self, request, client_address):
        """Start a new thread to process the request."""
        self.do_job_in_thread(self.do_work,  (request, client_address))
    
