import sys
import os
import subprocess

def run_cmd(cmd, msg="Failed to run command"):
    print('Running ' + ' '.join(cmd))
    if subprocess.check_call(cmd):
        print(msg)
        exit(1)


def run_cmd_cwd(cmd, cwd, msg):
    print('Change working directory to: ' + cwd)
    print('Running ' + ' '.join(cmd))
    if subprocess.check_call(cmd, cwd=cwd):
        print(msg)
        exit(1)


def get_argv(index, default):
    if len(sys.argv) > index:
        return sys.argv[index]
    return default


def trim_output_file(file):
    # Remove the leading and trailing bytes from the file
    length = os.stat(file).st_size
    if length < 20:
        contents = b''
    else:
        f = open(file, "rb")
        try:
            pre = f.read(2)
            print("Start characters in file skipped.", pre)
            contents = f.read(length - 5)
            post = f.read(3)
            print("End characters in file skipped.", post)
        finally:
            f.close()

    f = open(file, "wb")
    f.write(contents)
    f.close()


# remove all files with extension
def remove_files(path, ext):
    for file in os.listdir(path):
        if file.endswith(ext):
            os.remove(os.path.join(path, file))
