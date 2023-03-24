from __future__ import print_function

_indent_level = 0

_print = print

def print(*args, **kwargs):
    _print("  " * _indent_level, end="")
    _print(*args, **kwargs)

def enter(file_name):
    global _indent_level
    print("Entering {}".format(file_name))
    _indent_level += 1

def exit(file_name):
    global _indent_level
    _indent_level -= 1
    print("Leaving {}".format(file_name))

_status = 0

def status():
    return _status

def check(attr_path, actual_value, expected_value, bindings):
    global _status
    parts = attr_path.split(".")
    base, parts = parts[0], parts[1:]
    if base not in bindings:
        print("Error: {} not in bindings".format(base))
        _status = 1
        return
    val = bindings[base]
    for part in parts:
        if not hasattr(val, part):
            print("Error: Unknown attribute {}".format(part))
            _status = 1
            return
        val = getattr(val, part)
    if val != actual_value:
        print("Error: Value at path {} and actual value are out of sync! {} != {}".format(attr_path, val, actual_value))
        _status = 1
    if str(val).startswith("<module"):
        val = "<module " + val.__name__ + ">"
    if val != expected_value:
        print("Error: Expected {} to be {}, got {}".format(attr_path, expected_value, val))
        _status = 1
        return
    print("OK: {} = {}".format(attr_path, val))

__all__ = ["enter", "exit", "check", "status"]
