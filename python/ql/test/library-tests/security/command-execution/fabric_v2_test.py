"""tests for the 'fabric' package (v2.x)

Most of these examples are taken from the fabric documentation: http://docs.fabfile.org/en/2.5/getting-started.html
See fabric-LICENSE for its' license.
"""

from fabric import Connection

c = Connection('web1')
result = c.run('uname -s')

c.run(command='echo run with kwargs')


from fabric import SerialGroup as Group
results = Group('web1', 'web2', 'mac1').run('uname -s')


from fabric import SerialGroup as Group
pool = Group('web1', 'web2', 'web3')
pool.run('ls')



# using the 'fab' command-line tool

from fabric import task

@task
def upload_and_unpack(c):
    if c.run('test -f /opt/mydata/myfile', warn=True).failed:
        c.put('myfiles.tgz', '/opt/mydata')
        c.run('tar -C /opt/mydata -xzvf /opt/mydata/myfiles.tgz')
