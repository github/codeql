
from tg import request, validate, expose, TGController
from formencode import validators

class RootController(TGController):
    @expose()
    def onerror(self, **kwargs):
        return 'An error occurred: %s' % request.validation['errors']

    @expose()
    @validate({"a": validators.Int(not_empty=True), "b": validators.Email},
              error_handler=onerror)
    def ok_validated(self, a=None, b=None, *args):
        return 'Values: %s, %s, %s' % (a, b, args)

    @expose()
    @validate({"a": validators.Int(not_empty=True)})
    def partially_validated(self, a=None, b=None, *args):
        return 'Values: %s, %s, %s' % (a, b, args)

    @expose()
    def not_validated(self, a=None, b=None, *args):
        return 'Values: %s, %s, %s' % (a, b, args)

    @expose("<template_path>")
    def with_template(self):
        return {'template_var': 'foo'}
