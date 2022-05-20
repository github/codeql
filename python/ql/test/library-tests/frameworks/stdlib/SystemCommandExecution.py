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

os.popen("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
os.system("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


def os_members():
    # hmm, it's kinda annoying to check that we handle this import correctly for
    # everything. It's quite useful since I messed it up initially and didn't have a
    # test for it, but in the long run it's just cumbersome to duplicate all the tests
    # :|
    from os import popen, system

    popen("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
    system("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


########################################
# https://docs.python.org/3.8/library/os.html#os.execl
#
# VS Code extension will ignore rest of program if encountering one of these, which we
# don't want. We could use `if False`, but just to be 100% sure we don't do anything too
# clever in our analysis that discards that code, I used `if UNKNOWN` instead
#
# below, `path` is an relative/absolute path, for the `p` variants this could also be
# the name of a executable, which will be looked up in the PATH environment variable,
# which we call `file` to highlight this difference.
#
# These are also modeled as FileSystemAccess, although they are not super relevant for
# the path-injection query -- a user being able to control which program is executed
# doesn't sound safe even if that is restricted to be within a certain directory.
if UNKNOWN:
    env = {"FOO": "foo"}
    os.execl("path", "<progname>", "arg0")  # $ getCommand="path" getAPathArgument="path"
    os.execle("path", "<progname>", "arg0", env)  # $ getCommand="path" getAPathArgument="path"
    os.execlp("file", "<progname>", "arg0")  # $ getCommand="file" getAPathArgument="file"
    os.execlpe("file", "<progname>", "arg0", env)  # $ getCommand="file" getAPathArgument="file"
    os.execv("path", ["<progname>", "arg0"])  # $ getCommand="path" getAPathArgument="path"
    os.execve("path", ["<progname>", "arg0"], env)  # $ getCommand="path" getAPathArgument="path"
    os.execvp("file", ["<progname>", "arg0"])  # $ getCommand="file" getAPathArgument="file"
    os.execvpe("file", ["<progname>", "arg0"], env)  # $ getCommand="file" getAPathArgument="file"


########################################
# https://docs.python.org/3.8/library/os.html#os.spawnl
env = {"FOO": "foo"}
os.spawnl(os.P_WAIT, "path", "<progname>", "arg0")  # $ getCommand="path" getAPathArgument="path"
os.spawnle(os.P_WAIT, "path", "<progname>", "arg0", env)  # $ getCommand="path" getAPathArgument="path"
os.spawnlp(os.P_WAIT, "file", "<progname>", "arg0")  # $ getCommand="file" getAPathArgument="file"
os.spawnlpe(os.P_WAIT, "file", "<progname>", "arg0", env)  # $ getCommand="file" getAPathArgument="file"
os.spawnv(os.P_WAIT, "path", ["<progname>", "arg0"])  # $ getCommand="path" getAPathArgument="path"
os.spawnve(os.P_WAIT, "path", ["<progname>", "arg0"], env)  # $ getCommand="path" getAPathArgument="path"
os.spawnvp(os.P_WAIT, "file", ["<progname>", "arg0"])  # $ getCommand="file" getAPathArgument="file"
os.spawnvpe(os.P_WAIT, "file", ["<progname>", "arg0"], env)  # $ getCommand="file" getAPathArgument="file"

# unlike os.exec*, some os.spawn* functions is usable with keyword arguments. However,
# despite the docs using both `file` and `path` as the parameter name, you actually need
# to use `file` in all cases.
os.spawnv(mode=os.P_WAIT, file="path", args=["<progname>", "arg0"])  # $ getCommand="path" getAPathArgument="path"
os.spawnve(mode=os.P_WAIT, file="path", args=["<progname>", "arg0"], env=env)  # $ getCommand="path" getAPathArgument="path"
os.spawnvp(mode=os.P_WAIT, file="file", args=["<progname>", "arg0"])  # $ getCommand="file" getAPathArgument="file"
os.spawnvpe(mode=os.P_WAIT, file="file", args=["<progname>", "arg0"], env=env)  # $ getCommand="file" getAPathArgument="file"

# `posix_spawn` Added in Python 3.8
os.posix_spawn("path", ["<progname>", "arg0"], env)  # $ getCommand="path" getAPathArgument="path"
os.posix_spawn(path="path", argv=["<progname>", "arg0"], env=env)  # $ getCommand="path" getAPathArgument="path"

os.posix_spawnp("path", ["<progname>", "arg0"], env)  # $ getCommand="path" getAPathArgument="path"
os.posix_spawnp(path="path", argv=["<progname>", "arg0"], env=env)  # $ getCommand="path" getAPathArgument="path"

########################################

import subprocess

subprocess.Popen("cmd1; cmd2", shell=True)  # $getCommand="cmd1; cmd2"
subprocess.Popen("cmd1; cmd2", shell="truthy string")  # $getCommand="cmd1; cmd2"
subprocess.Popen(["cmd1; cmd2", "shell-arg"], shell=True)  # $getCommand="cmd1; cmd2"
subprocess.Popen("cmd1; cmd2", shell=True, executable="/bin/bash")  # $getCommand="cmd1; cmd2" getCommand="/bin/bash"

subprocess.Popen("executable")  # $getCommand="executable"
subprocess.Popen(["executable", "arg0"])  # $getCommand="executable"
subprocess.Popen("<progname>", executable="executable")  # $getCommand="executable"
subprocess.Popen(["<progname>", "arg0"], executable="executable")  # $getCommand="executable"

# call/check_call/check_output/run all work like Popen from a command execution point of view
subprocess.call(["executable", "arg0"])  # $getCommand="executable"
subprocess.check_call(["executable", "arg0"])  # $getCommand="executable"
subprocess.check_output(["executable", "arg0"])  # $getCommand="executable"
subprocess.run(["executable", "arg0"])  # $getCommand="executable"


########################################
# actively using known shell as the executable

subprocess.Popen(["/bin/sh", "-c", "vuln"])  # $getCommand="/bin/sh" MISSING: getCommand="vuln"
subprocess.Popen(["/bin/bash", "-c", "vuln"])  # $getCommand="/bin/bash" MISSING: getCommand="vuln"
subprocess.Popen(["/bin/dash", "-c", "vuln"])  # $getCommand="/bin/dash" MISSING: getCommand="vuln"
subprocess.Popen(["/bin/zsh", "-c", "vuln"])  # $getCommand="/bin/zsh" MISSING: getCommand="vuln"

subprocess.Popen(["sh", "-c", "vuln"])  # $getCommand="sh" MISSING: getCommand="vuln"
subprocess.Popen(["bash", "-c", "vuln"])  # $getCommand="bash" MISSING: getCommand="vuln"
subprocess.Popen(["dash", "-c", "vuln"])  # $getCommand="dash" MISSING: getCommand="vuln"
subprocess.Popen(["zsh", "-c", "vuln"])  # $getCommand="zsh" MISSING: getCommand="vuln"

# Check that we don't consider ANY argument a command injection sink
subprocess.Popen(["sh", "/bin/python"])  # $getCommand="sh"

subprocess.Popen(["cmd.exe", "/c", "vuln"])  # $getCommand="cmd.exe" MISSING: getCommand="vuln"
subprocess.Popen(["cmd.exe", "/C", "vuln"])  # $getCommand="cmd.exe" MISSING: getCommand="vuln"
subprocess.Popen(["cmd", "/c", "vuln"])  # $getCommand="cmd" MISSING: getCommand="vuln"
subprocess.Popen(["cmd", "/C", "vuln"])  # $getCommand="cmd" MISSING: getCommand="vuln"

subprocess.Popen(["<progname>", "-c", "vuln"], executable="/bin/bash")  # $getCommand="/bin/bash" MISSING: getCommand="vuln"

if UNKNOWN:
    os.execl("/bin/sh", "<progname>", "-c", "vuln")  # $getCommand="/bin/sh" getAPathArgument="/bin/sh" MISSING: getCommand="vuln"

os.spawnl(os.P_WAIT, "/bin/sh", "<progname>", "-c", "vuln")  # $getCommand="/bin/sh" getAPathArgument="/bin/sh" MISSING: getCommand="vuln"


########################################
# Passing arguments by reference

args = ["/bin/sh", "-c", "vuln"]
subprocess.Popen(args)  # $getCommand=args

args = "<progname>"
use_shell = False
exe = "executable"
subprocess.Popen(args, shell=use_shell, executable=exe)  # $getCommand=exe SPURIOUS: getCommand=args


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
