
try:

    @decorator
    class S(object):

        def __init__(self, *args, **kwargs):
            super(S, self).__init__(*args, **kwargs)

except Exception:

    class S(object):
        pass
