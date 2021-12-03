class remotelock(object):     # Resources can be released using __del__

    def __init__(self, repo):
        self.repo = repo

    def release(self):
        self.repo.unlock()
        self.repo = None

    def __del__(self):
        if self.repo:
            self.release()


class remotelock2(object):     # Resources can be released using a with statement

    def __init__(self, repo):
        self.repo = repo

    def __enter__(self):
        return self

    def release(self):
        self.repo.unlock()
        self.repo = None
        
    def __del__(self):
        if self.repo:
            self.release()

    def __exit__(self, exct_type, exce_value, traceback):
        if self.repo:
            self.release()
