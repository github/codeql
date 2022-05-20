
class Environment(object):

    def __init__(self, loader, autoescape):
        pass

class Template(object):

    def __init__(self, source, autoescape):
        pass

def select_autoescape(files=[]):
    def autoescape(template_name):
        pass
    return autoescape

class FileSystemLoader(object):

    def __init__(self, searchpath):
        pass

def from_string(source, globals=None, template_class=None):
    pass