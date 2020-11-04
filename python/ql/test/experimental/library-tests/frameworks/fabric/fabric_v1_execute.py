"""Test that shows fabric.api.execute propagates taint"""

from fabric.api import run, execute


def unsafe(cmd, safe_arg, cmd2=None, safe_optional=5):
    ensure_tainted(cmd, cmd2)
    ensure_not_tainted(safe_arg, safe_optional)


class Foo(object):

    def unsafe(self, cmd, safe_arg, cmd2=None, safe_optional=5):
        ensure_tainted(cmd, cmd2)
        ensure_not_tainted(safe_arg, safe_optional)


def some_http_handler():
    cmd = TAINTED_STRING
    cmd2 = TAINTED_STRING
    ensure_tainted(cmd, cmd2)

    execute(unsafe, cmd=cmd, safe_arg='safe_arg', cmd2=cmd2)

    foo = Foo()
    execute(foo.unsafe, cmd, 'safe_arg', cmd2)
