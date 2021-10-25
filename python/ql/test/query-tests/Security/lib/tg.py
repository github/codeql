
def validate(validators):
    def validator(func):
        return func

def expose(*args):
    if cond:
        return args[0]
    def with_template(func):
        func
    return with_template

class TGController(object):
    pass

class TurboGearsContextMember(object):
    """Member of the TurboGears request context.
    Provides access to turbogears context members
    like request, response, template context and so on
    """

    def __init__(self, name):
        self.__dict__['name'] = name

    def _current_obj(self):
        return getattr(context, self.name)


request = TurboGearsContextMember(name="request")
response = TurboGearsContextMember(name="response")
