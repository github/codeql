import subprocess
from subprocess import Popen as pop


def Popen(*args, **kwargs):
    print('hi')

    def __len__(self):
        return 0

pop('/bin/gcc --version', shell=True)
Popen('/bin/gcc --version', shell=True)

subprocess.Popen('/bin/gcc --version', shell=True)
subprocess.Popen(['/bin/gcc', '--version'], shell=False)
subprocess.Popen(['/bin/gcc', '--version'])

subprocess.call(["/bin/ls",
                 "-l"
                 ])
subprocess.call('/bin/ls -l', shell=True)

subprocess.check_call(['/bin/ls', '-l'], shell=False)
subprocess.check_call('/bin/ls -l', shell=True)

subprocess.check_output(['/bin/ls', '-l'])
subprocess.check_output('/bin/ls -l', shell=True)

subprocess.run(['/bin/ls', '-l'])
subprocess.run('/bin/ls -l', shell=True)

subprocess.Popen('/bin/ls *', shell=True)
subprocess.Popen('/bin/ls %s' % ('something',), shell=True)
subprocess.Popen('/bin/ls {}'.format('something'), shell=True)

command = "/bin/ls" + unknown_function()
subprocess.Popen(command, shell=True)

subprocess.Popen('/bin/ls && cat /etc/passwd', shell=True)

command = 'pwd'
subprocess.call(command, shell='True')
subprocess.call(command, shell='False')
subprocess.call(command, shell='None')
subprocess.call(command, shell=1)

subprocess.call(command, shell=Popen())
subprocess.call(command, shell=[True])
subprocess.call(command, shell={'IS': 'True'})
subprocess.call(command, shell=command)

subprocess.call(command, shell=False)
subprocess.call(command, shell=0)
subprocess.call(command, shell=[])
subprocess.call(command, shell={})
subprocess.call(command, shell=None)
