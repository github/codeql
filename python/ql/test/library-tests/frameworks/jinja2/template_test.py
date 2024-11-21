from jinja2 import Environment, Template

def test():
    env = Environment()
    t = env.from_string("abc") # $ templateConstruction="abc"
    t = Template("abc") # $ templateConstruction="abc"
    return t