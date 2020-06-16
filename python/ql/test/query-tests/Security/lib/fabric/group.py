class Group(list):
    def run(self, *args, **kwargs):
        raise NotImplementedError

class SerialGroup(Group):
    def run(self, *args, **kwargs):
        pass

class ThreadingGroup(Group):
    def run(self, *args, **kwargs):
        pass
