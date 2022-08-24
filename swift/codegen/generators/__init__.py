from . import dbschemegen, qlgen, trapgen, cppgen


def generate(target, opts, renderer):
    module = globals()[f"{target}gen"]
    module.generate(opts, renderer)
