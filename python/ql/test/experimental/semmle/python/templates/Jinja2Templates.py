from jinja2 import Template as Jinja2_Template
from jinja2 import Environment, DictLoader, escape


def jinja():
    t = Jinja2_Template("sink")


def jinja2():
    random = "esdad" + "asdad"
    t = Jinja2_Template(random)


def jinja3():
    random = 1234
    t = Jinja2_Template("sink"+random)

