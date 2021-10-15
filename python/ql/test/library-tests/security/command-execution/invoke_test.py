"""tests for the 'invoke' package

see https://www.pyinvoke.org/
"""

import invoke

invoke.run('echo run')
invoke.run(command='echo run with kwarg')

def with_sudo():
    invoke.sudo('whoami')
    invoke.sudo(command='whoami')

def manual_context():
    c = invoke.Context()
    c.run('echo run from manual context')
manual_context()

def foo_helper(c):
    c.run('echo from foo_helper')

# for use with the 'invoke' command-line tool
@invoke.task
def foo(c):
    # 'c' is a invoke.context.Context
    c.run('echo task foo')
    foo_helper(c)

@invoke.task()
def bar(c):
    c.run('echo task bar')
