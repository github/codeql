
DEFAULT = "default"

def get_color(name, fallback):
    if name in COLORS:
        return COLORS[name]
    elif fallback is DEFAULT:
        return DEFAULT_COLOR
    else:
        return fallback

#This works
print (get_color("spam", "def" + "ault"))

#But this does not
print (get_color("spam", "default-spam"[:7]))

#To fix the above code change to object
DEFAULT = object()

#Or if you want better repr() output:
class Default(object):

    def __repr__(self):
        return "DEFAULT"

DEFAULT = Default()
