from . import dbschemegen, trapgen, cppgen, rustgen, rusttestgen, qlgen


def generate(target, opts, renderer):
    module = globals()[f"{target}gen"]
    module.generate(opts, renderer)
