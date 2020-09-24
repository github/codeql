# Note: Some of these commands will technically not allow an attacker to execute
# arbitrary system commands, but only specify the program to be executed. The general
# consensus was that even this is still a high security risk, so we also treat them as
# system command executions.
#
# As an example, executing `subprocess.Popen(["rm -rf /"])` will result in
# `FileNotFoundError: [Errno 2] No such file or directory: 'rm -rf /'`

########################################


import os

# can't use a string literal with spaces in the tags of an InlineExpectationsTest, so using variables :|

os.popen("cmd1; cmd2")  # $SystemCommandExecution_getCommand="cmd1; cmd2"
os.system("cmd1; cmd2")  # $SystemCommandExecution_getCommand="cmd1; cmd2"


def os_members():
    # hmm, it's kinda annoying to check that we handle this import correctly for
    # everything. It's quite useful since I messed it up initially and didn't have a
    # test for it, but in the long run it's just cumbersome to duplicate all the tests
    # :|
    from os import popen, system

    popen("cmd1; cmd2")  # $SystemCommandExecution_getCommand="cmd1; cmd2"
    system("cmd1; cmd2")  # $SystemCommandExecution_getCommand="cmd1; cmd2"


########################################
# https://docs.python.org/3.8/library/os.html#os.execv
#
# VS Code extension will ignore rest of program if encountering one of these, which we
# don't want. We could use `if False`, but just to be 100% sure we don't do anything too
# clever in our analysis that discards that code, I used `if UNKNOWN` instead
if UNKNOWN:
    env = {"FOO": "foo"}
    os.execl("executable", "<progname>", "arg0")  # $f-:SystemCommandExecution_getCommand="executable"
    os.execle("executable", "<progname>", "arg0", env)  # $f-:SystemCommandExecution_getCommand="executable"
    os.execlp("executable", "<progname>", "arg0")  # $f-:SystemCommandExecution_getCommand="executable"
    os.execlpe("executable", "<progname>", "arg0", env)  # $f-:SystemCommandExecution_getCommand="executable"
    os.execv("executable", ["<progname>", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
    os.execve("executable", ["<progname>", "arg0"], env)  # $f-:SystemCommandExecution_getCommand="executable"
    os.execvp("executable", ["<progname>", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
    os.execvpe("executable", ["<progname>", "arg0"], env)  # $f-:SystemCommandExecution_getCommand="executable"


########################################
# https://docs.python.org/3.8/library/os.html#os.spawnl
env = {"FOO": "foo"}
os.spawnl(os.P_WAIT, "executable", "<progname>", "arg0")  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnle(os.P_WAIT, "executable", "<progname>", "arg0", env)  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnlp(os.P_WAIT, "executable", "<progname>", "arg0")  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnlpe(os.P_WAIT, "executable", "<progname>", "arg0", env)  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnv(os.P_WAIT, "executable", ["<progname>", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnve(os.P_WAIT, "executable", ["<progname>", "arg0"], env)  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnvp(os.P_WAIT, "executable", ["<progname>", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
os.spawnvpe(os.P_WAIT, "executable", ["<progname>", "arg0"], env)  # $f-:SystemCommandExecution_getCommand="executable"

# Added in Python 3.8
os.posix_spawn("executable", ["<progname>", "arg0"], env)  # $f-:SystemCommandExecution_getCommand="executable"
os.posix_spawnp("executable", ["<progname>", "arg0"], env)  # $f-:SystemCommandExecution_getCommand="executable"

########################################

import subprocess

subprocess.Popen("cmd1; cmd2", shell=True)  # $f-:SystemCommandExecution_getCommand="cmd1; cmd2"
subprocess.Popen("cmd1; cmd2", shell="truthy string")  # $f-:SystemCommandExecution_getCommand="cmd1; cmd2"
subprocess.Popen(["cmd1; cmd2", "shell-arg"], shell=True)  # $f-:SystemCommandExecution_getCommand="cmd1; cmd2"
subprocess.Popen("cmd1; cmd2", shell=True, executable="/bin/bash")  # $f-:SystemCommandExecution_getCommand="cmd1; cmd2"

subprocess.Popen("executable")  # $f-:SystemCommandExecution_getCommand="executable"
subprocess.Popen(["executable", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
subprocess.Popen("<progname>", executable="executable")  # $f-:SystemCommandExecution_getCommand="executable"
subprocess.Popen(["<progname>", "arg0"], executable="executable")  # $f-:SystemCommandExecution_getCommand="executable"

# call/check_call/check_output/run all work like Popen from a command execution point of view
subprocess.call(["executable", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
subprocess.check_call(["executable", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
subprocess.check_output(["executable", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"
subprocess.run(["executable", "arg0"])  # $f-:SystemCommandExecution_getCommand="executable"


########################################
# actively using known shell as the executable

subprocess.Popen(["/bin/sh", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="/bin/sh",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["/bin/bash", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="/bin/bash",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["/bin/dash", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="/bin/dash",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["/bin/zsh", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="/bin/zsh",$f-:SystemCommandExecution_getCommand="vuln"

subprocess.Popen(["sh", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="sh",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["bash", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="bash",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["dash", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="dash",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["zsh", "-c", "vuln"])  # $f-:SystemCommandExecution_getCommand="zsh",$f-:SystemCommandExecution_getCommand="vuln"

# Check that we don't consider ANY argument a command injection sink
subprocess.Popen(["sh", "/bin/python"])  # $f-:SystemCommandExecution_getCommand="sh"

subprocess.Popen(["cmd.exe", "/c", "vuln"])  # $f-:SystemCommandExecution_getCommand="cmd.exe",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["cmd.exe", "/C", "vuln"])  # $f-:SystemCommandExecution_getCommand="cmd.exe",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["cmd", "/c", "vuln"])  # $f-:SystemCommandExecution_getCommand="cmd",$f-:SystemCommandExecution_getCommand="vuln"
subprocess.Popen(["cmd", "/C", "vuln"])  # $f-:SystemCommandExecution_getCommand="cmd",$f-:SystemCommandExecution_getCommand="vuln"


################################################################################
# Taint related

import shlex

cmd = shlex.join(["echo", tainted])
args = shlex.split(tainted)

# will handle tainted = 'foo; rm -rf /'
safe_cmd = "ls {}".format(shlex.quote(tainted))

# not how you are supposed to use shlex.quote
wrong_use = shlex.quote("ls {}".format(tainted))
# still dangerous, for example
cmd = "sh -c " + wrong_use
