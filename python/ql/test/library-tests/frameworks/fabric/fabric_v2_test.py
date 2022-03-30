"""tests for the 'fabric' package (v2.x)

Loosely inspired by http://docs.fabfile.org/en/2.5/getting-started.html
"""

from fabric import connection, Connection, group, SerialGroup, ThreadingGroup, tasks, task


################################################################################
# Connection
################################################################################
c = Connection("web1")
c.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
c.local("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
c.sudo("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

c.local(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
c.run(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
c.sudo(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"

# fully qualified usage
c2 = connection.Connection("web2")
c2.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


################################################################################
# SerialGroup
################################################################################
results = SerialGroup("web1", "web2", "mac1").run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

pool = SerialGroup("web1", "web2", "web3")
pool.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

# fully qualified usage
group.SerialGroup("web1", "web2", "mac1").run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


################################################################################
# ThreadingGroup
################################################################################
results = ThreadingGroup("web1", "web2", "mac1").run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

pool = ThreadingGroup("web1", "web2", "web3")
pool.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

# fully qualified usage
group.ThreadingGroup("web1", "web2", "mac1").run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


################################################################################
# task decorator
# using the 'fab' command-line tool
################################################################################

@task
def foo(c):
    # 'c' is a fabric.connection.Connection
    c.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

# fully qualified usage
@tasks.task
def bar(c):
    # 'c' is a fabric.connection.Connection
    c.run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
