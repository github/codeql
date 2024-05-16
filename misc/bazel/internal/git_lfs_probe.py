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
import base64
from dataclasses import dataclass
from typing import Dict


@dataclass
class Endpoint:
    href: str
    headers: Dict[str, str]

    def update_headers(self, d: Dict[str, str]):
        self.headers.update((k.capitalize(), v) for k, v in d.items())


sources = [pathlib.Path(arg).resolve() for arg in sys.argv[1:]]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))
source_dir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=source_dir, text=True).strip()


def get_env(s, sep="="):
    ret = {}
    for m in re.finditer(fr'(.*?){sep}(.*)', s, re.M):
        ret.setdefault(*m.groups())
    return ret


def git(*args, **kwargs):
    return subprocess.run(("git",) + args, stdout=subprocess.PIPE, text=True, cwd=source_dir, **kwargs).stdout.strip()


def get_endpoint():
    lfs_env = get_env(subprocess.check_output(["git", "lfs", "env"], text=True, cwd=source_dir))
    endpoint = next(v for k, v in lfs_env.items() if k.startswith('Endpoint'))
    endpoint, _, _ = endpoint.partition(' ')
    ssh_endpoint = lfs_env.get("  SSH")
    endpoint = Endpoint(endpoint, {
        "Content-Type": "application/vnd.git-lfs+json",
        "Accept": "application/vnd.git-lfs+json",
    })
    if ssh_endpoint:
        # see https://github.com/git-lfs/git-lfs/blob/main/docs/api/authentication.md
        server, _, path = ssh_endpoint.partition(":")
        ssh_command = shutil.which(os.environ.get("GIT_SSH", os.environ.get("GIT_SSH_COMMAND", "ssh")))
        assert ssh_command, "no ssh command found"
        resp = json.loads(subprocess.check_output([ssh_command, server, "git-lfs-authenticate", path, "download"]))
        endpoint.href = resp.get("href", endpoint)
        endpoint.update_headers(resp.get("header", {}))
    url = urlparse(endpoint.href)
    # this is how actions/checkout persist credentials
    # see https://github.com/actions/checkout/blob/44c2b7a8a4ea60a981eaca3cf939b5f4305c123b/src/git-auth-helper.ts#L56-L63
    auth = git("config", f"http.{url.scheme}://{url.netloc}/.extraheader")
    endpoint.update_headers(get_env(auth, sep=": "))
    if os.environ.get("GITHUB_TOKEN"):
        endpoint.headers["Authorization"] = f"token {os.environ['GITHUB_TOKEN']}"
    if "Authorization" not in endpoint.headers:
        # last chance: use git credentials (possibly backed by a credential helper like the one installed by gh)
        # see https://git-scm.com/docs/git-credential
        credentials = get_env(git("credential", "fill", check=True,
                                  # drop leading / from url.path
                                  input=f"protocol={url.scheme}\nhost={url.netloc}\npath={url.path[1:]}\n"))
        auth = base64.b64encode(f'{credentials["username"]}:{credentials["password"]}'.encode()).decode('ascii')
        endpoint.headers["Authorization"] = f"Basic {auth}"
    return endpoint


# see https://github.com/git-lfs/git-lfs/blob/310d1b4a7d01e8d9d884447df4635c7a9c7642c2/docs/api/basic-transfers.md
def get_locations(objects):
    ret = ["local" for _ in objects]
    endpoint = get_endpoint()
    indexes = [i for i, o in enumerate(objects) if o]
    if not indexes:
        # all objects are local, do not send an empty request as that would be an error
        return ret
    data = {
        "operation": "download",
        "transfers": ["basic"],
        "objects": [objects[i] for i in indexes],
        "hash_algo": "sha256",
    }
    req = urllib.request.Request(
        f"{endpoint.href}/objects/batch",
        headers=endpoint.headers,
        data=json.dumps(data).encode("ascii"),
    )
    with urllib.request.urlopen(req) as resp:
        data = json.load(resp)
    assert len(data["objects"]) == len(indexes), f"received {len(data)} objects, expected {len(indexes)}"
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
        data = get_env(fileobj.read().decode('ascii'), sep=' ')
        assert data['oid'].startswith('sha256:'), f"unknown oid type: {data['oid']}"
        _, _, sha256 = data['oid'].partition(':')
        size = int(data['size'])
        return {"oid": sha256, "size": size}


objects = [get_lfs_object(src) for src in sources]
for resp in get_locations(objects):
    print(resp)
