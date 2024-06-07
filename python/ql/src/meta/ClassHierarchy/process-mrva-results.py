#!/usr/bin/env python3

import sys
import glob
import json
import subprocess
from collections import defaultdict
import shutil
import os

from shared_subclass_functions import *

assert mad_path.exists(), mad_path



# process data

class CodeQL:
    def __init__(self):
        pass

    def __enter__(self):
        self.proc = subprocess.Popen(['codeql', 'execute','cli-server'],
                      executable=shutil.which('codeql'),
                      stdin=subprocess.PIPE,
                      stdout=subprocess.PIPE,
                      stderr=sys.stderr,
                      env=os.environ.copy(),
                     )
        return self
    def __exit__(self, type, value, tb):
        self.proc.stdin.write(b'["shutdown"]\0')
        self.proc.stdin.close()
        try:
            self.proc.wait(5)
        except:
            self.proc.kill()

    def command(self, args):
        data = json.dumps(args)
        data_bytes = data.encode('utf-8')
        self.proc.stdin.write(data_bytes)
        self.proc.stdin.write(b'\0')
        self.proc.stdin.flush()
        res = b''
        while True:
           b = self.proc.stdout.read(1)
           if b == b'\0':
               return res.decode('utf-8')
           res += b


def gather_from_bqrs_results():
    package_data = defaultdict(set)
    with CodeQL() as codeql:
        if os.path.exists(sys.argv[1]) and not os.path.isdir(sys.argv[1]) and sys.argv[1].endswith(".bqrs"):
            files = [sys.argv[1]]
        else:
            files = glob.glob(f"{sys.argv[1]}/**.bqrs", recursive=True)

        for f in files:
            print(f"Processing {f}")

            json_data = codeql.command(["bqrs", "decode", "--format=json", f])
            select = json.loads(json_data)

            for t in select["#select"]["tuples"]:
                pkg = t[1]
                package_data[pkg].add(tuple(t))
    return package_data


if __name__ == "__main__":
    if joined_file.exists():
        sys.exit(f"File {joined_file} exists, you should split it up first")

    package_data = gather_from_bqrs_results()
    write_all_package_data_to_files(package_data)
