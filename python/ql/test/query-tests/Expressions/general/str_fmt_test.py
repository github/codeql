

def expected_mapping_for_fmt_string():
    x = [ u'list', u'not', u'mapping' ]
    print (u"%(name)s" % x)

def unsupported_format_char(arg):
    print (u"%Z" % arg)

def wrong_arg_count_format(arg):
    print(u"%s %s" % (arg, arg, 0))
    format = u"%hd"
    args = (1, u'foo')
    print(format % args)


def ok():
    # allowable length modifiers
    print(u"%hd %ld %Ld" % (1,2,3))

    # multiple adjacent % characters
    print(u"%%%s" % u"(foo)s")

    # '.' without trailing digits
    print(u"%2.d" % 3)

    # a list is OK as an argument to %s
    print(u"%s is a list" % [1,2,3,4])

    # pretty much everything
    print(u"%(var)#0+- 8.4hd" % dict(var=44))

    #This one from PyPy tests
    print(u"%()s" % { u'' : u'Hi' })

#ODASA 6401
out = '<Transform rotation="0 1 0 %s">\n'
out+= '    <Transform rotation="1 0 0 %s">\n'

light = out % (az, al)

#Example from CPython
def f(k, v):
    print('    %-40s%a,' % ('%a:' % k, v))

#Context sensitive
def g(a, b):
    return a % b

g("%s", 1)
g("%s %s", (1, 2))

#Make sure we handle all format characters
"%b %d %i %o %u %x %X %e %E %f %F %g %G %c %r %s" % t()

