#!/usr/bin/env python3

"""
Probe lfs files.
For each source file provided as output, this will print:
* "local", if the source file is not an LFS pointer
* the sha256 hash, a space character and a transient download link obtained via the LFS protocol otherwise
"""

import sys
import pathlib
import subprocess
import os
import shutil
import json
import urllib.request
from urllib.parse import urlparse
import re

sources = [pathlib.Path(arg).resolve() for arg in sys.argv[1:]]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))
source_dir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=source_dir, text=True).strip()


def get_endpoint():
    lfs_env = subprocess.check_output(["git", "lfs", "env"], text=True, cwd=source_dir)
    endpoint = ssh_server = ssh_path = None
    endpoint_re = re.compile(r'Endpoint(?: \(\S+\))?=(\S+)')
    ssh_re = re.compile(r'\s*SSH=(\S*):(.*)')
    for line in lfs_env.splitlines():
        m = endpoint_re.match(line)
        if m:
            if endpoint is None:
                endpoint = m[1]
            else:
                break
        m = ssh_re.match(line)
        if m:
            ssh_server, ssh_path = m.groups()
            break
    assert endpoint, f"no Endpoint= line found in git lfs env:\n{lfs_env}"
    headers = {
        "Content-Type": "application/vnd.git-lfs+json",
        "Accept": "application/vnd.git-lfs+json",
    }
    if ssh_server:
        ssh_command = shutil.which(os.environ.get("GIT_SSH", os.environ.get("GIT_SSH_COMMAND", "ssh")))
        assert ssh_command, "no ssh command found"
        with subprocess.Popen([ssh_command, ssh_server, "git-lfs-authenticate", ssh_path, "download"],
                              stdout=subprocess.PIPE) as ssh:
            resp = json.load(ssh.stdout)
            assert ssh.wait() == 0, "ssh command failed"
        endpoint = resp.get("href", endpoint)
        for k, v in resp.get("header", {}).items():
            headers[k.capitalize()] = v
    url = urlparse(endpoint)
    # this is how actions/checkout persist credentials
    # see https://github.com/actions/checkout/blob/44c2b7a8a4ea60a981eaca3cf939b5f4305c123b/src/git-auth-helper.ts#L56-L63
    auth = subprocess.run(["git", "config", f"http.{url.scheme}://{url.netloc}/.extraheader"], text=True,
                          stdout=subprocess.PIPE, cwd=source_dir).stdout.strip()
    for l in auth.splitlines():
        k, _, v = l.partition(": ")
        headers[k.capitalize()] = v
    if "GITHUB_TOKEN" in os.environ:
        headers["Authorization"] = f"token {os.environ['GITHUB_TOKEN']}"
    return endpoint, headers


# see https://github.com/git-lfs/git-lfs/blob/310d1b4a7d01e8d9d884447df4635c7a9c7642c2/docs/api/basic-transfers.md
def get_locations(objects):
    href, headers = get_endpoint()
    indexes = [i for i, o in enumerate(objects) if o]
    ret = ["local" for _ in objects]
    req = urllib.request.Request(
        f"{href}/objects/batch",
        headers=headers,
        data=json.dumps({
            "operation": "download",
            "transfers": ["basic"],
            "objects": [o for o in objects if o],
            "hash_algo": "sha256",
        }).encode("ascii"),
    )
    with urllib.request.urlopen(req) as resp:
        data = json.load(resp)
    assert len(data["objects"]) == len(indexes), data
    for i, resp in zip(indexes, data["objects"]):
        ret[i] = f'{resp["oid"]} {resp["actions"]["download"]["href"]}'
    return ret


def get_lfs_object(path):
    with open(path, 'rb') as fileobj:
        lfs_header = "version https://git-lfs.github.com/spec".encode()
        actual_header = fileobj.read(len(lfs_header))
        sha256 = size = None
        if lfs_header != actual_header:
            return None
        for line in fileobj:
            line = line.decode('ascii').strip()
            if line.startswith("oid sha256:"):
                sha256 = line[len("oid sha256:"):]
            elif line.startswith("size "):
                size = int(line[len("size "):])
        if not (sha256 and line):
            raise Exception("malformed pointer file")
        return {"oid": sha256, "size": size}


objects = [get_lfs_object(src) for src in sources]
for resp in get_locations(objects):
    print(resp)
