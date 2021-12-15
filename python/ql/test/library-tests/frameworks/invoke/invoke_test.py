"""tests for the 'invoke' package

see https://www.pyinvoke.org/
"""

import invoke

invoke.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
invoke.run(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"


def with_sudo():
    invoke.sudo("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
    invoke.sudo(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"


def manual_context():
    c = invoke.Context()
    c.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
    c.sudo("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

    # invoke.Context is just an alias for invoke.context.Context
    c2 = invoke.context.Context()
    c2.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


manual_context()


def foo_helper(c):
    c.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


# for use with the 'invoke' command-line tool
@invoke.task
def foo(c):
    # 'c' is a invoke.context.Context
    c.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
    foo_helper(c)
