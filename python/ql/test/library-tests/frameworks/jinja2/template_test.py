from jinja2 import Environment, Template
from jinja2.sandbox import SandboxedEnvironment

def test():
    env = Environment()
    t = env.from_string("abc") # $ templateConstruction="abc"
    t = Template("abc") # $ templateConstruction="abc"

    env2 = SandboxedEnvironment()
    t = env2.from_string("abc") # No result as we don't model SandboxedEnvironment. We may wish to instead specifically model it as NOT vulnerable to template injection vulnerabilities.
    return t