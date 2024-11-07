#!/usr/bin/env python3

"""
Probe lfs files.
For each source file provided as input, this will print:
* "local", if the source file is not an LFS pointer
* the sha256 hash, a space character and a transient download link obtained via the LFS protocol otherwise
If --hash-only is provided, the transient URL will not be fetched and printed
"""
import dataclasses
import sys
import pathlib
import subprocess
import os
import shutil
import json
import typing
import urllib.request
import urllib.error
from urllib.parse import urlparse
import re
import base64
from dataclasses import dataclass
import argparse

def options():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--hash-only", action="store_true")
    p.add_argument("sources", type=pathlib.Path, nargs="+")
    return p.parse_args()


TIMEOUT = 20

def warn(message: str) -> None:
    print(f"WARNING: {message}", file=sys.stderr)


@dataclass
class Endpoint:
    name: str
    href: str
    ssh: typing.Optional[str] = None
    headers: typing.Dict[str, str] = dataclasses.field(default_factory=dict)

    def update_headers(self, d: typing.Iterable[typing.Tuple[str, str]]):
        self.headers.update((k.capitalize(), v) for k, v in d)


class NoEndpointsFound(Exception):
    pass


opts = options()
sources = [p.resolve() for p in opts.sources]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))
source_dir = subprocess.check_output(
    ["git", "rev-parse", "--show-toplevel"], cwd=source_dir, text=True
).strip()


def get_env(s: str, sep: str = "=") -> typing.Iterable[typing.Tuple[str, str]]:
    for m in re.finditer(rf"(.*?){sep}(.*)", s, re.M):
        yield m.groups()


def git(*args, **kwargs):
    proc = subprocess.run(
        ("git",) + args, stdout=subprocess.PIPE, text=True, cwd=source_dir, **kwargs
    )
    return proc.stdout.strip() if proc.returncode == 0 else None


endpoint_re = re.compile(r"^Endpoint(?: \((.*)\))?$")


def get_endpoint_addresses() -> typing.Iterable[Endpoint]:
    """Get all lfs endpoints, including SSH if present"""
    lfs_env_items = get_env(
        subprocess.check_output(["git", "lfs", "env"], text=True, cwd=source_dir)
    )
    current_endpoint = None
    for k, v in lfs_env_items:
        m = endpoint_re.match(k)
        if m:
            if current_endpoint:
                yield current_endpoint
            href, _, _ = v.partition(" ")
            current_endpoint = Endpoint(name=m[1] or "default", href=href)
        elif k == "  SSH" and current_endpoint:
            current_endpoint.ssh = v
    if current_endpoint:
        yield current_endpoint


def get_endpoints() -> typing.Iterable[Endpoint]:
    for endpoint in get_endpoint_addresses():
        endpoint.headers = {
            "Content-Type": "application/vnd.git-lfs+json",
            "Accept": "application/vnd.git-lfs+json",
        }
        if endpoint.ssh:
            # see https://github.com/git-lfs/git-lfs/blob/main/docs/api/authentication.md
            server, _, path = endpoint.ssh.partition(":")
            ssh_command = shutil.which(
                os.environ.get("GIT_SSH", os.environ.get("GIT_SSH_COMMAND", "ssh"))
            )
            assert ssh_command, "no ssh command found"
            cmd = [
                ssh_command,
                "-oStrictHostKeyChecking=accept-new",
                server,
                "git-lfs-authenticate",
                path,
                "download",
            ]
            try:
                res = subprocess.run(cmd, stdout=subprocess.PIPE, timeout=TIMEOUT)
            except subprocess.TimeoutExpired:
                warn(f"ssh timed out when connecting to {server}, ignoring {endpoint.name} endpoint")
                continue
            if res.returncode != 0:
                warn(f"ssh failed when connecting to {server}, ignoring {endpoint.name} endpoint")
                continue
            ssh_resp = json.loads(res.stdout)
            endpoint.href = ssh_resp.get("href", endpoint)
            endpoint.update_headers(ssh_resp.get("header", {}).items())
        url = urlparse(endpoint.href)
        # this is how actions/checkout persist credentials
        # see https://github.com/actions/checkout/blob/44c2b7a8a4ea60a981eaca3cf939b5f4305c123b/src/git-auth-helper.ts#L56-L63
        auth = git("config", f"http.{url.scheme}://{url.netloc}/.extraheader") or ""
        endpoint.update_headers(get_env(auth, sep=": "))
        if os.environ.get("GITHUB_TOKEN"):
            endpoint.headers["Authorization"] = f"token {os.environ['GITHUB_TOKEN']}"
        if "Authorization" not in endpoint.headers:
            # last chance: use git credentials (possibly backed by a credential helper like the one installed by gh)
            # see https://git-scm.com/docs/git-credential
            credentials = git(
                "credential",
                "fill",
                check=True,
                # drop leading / from url.path
                input=f"protocol={url.scheme}\nhost={url.netloc}\npath={url.path[1:]}\n",
            )
            if credentials is None:
                warn(f"no authorization method found, ignoring {endpoint.name} endpoint")
                continue
            credentials = dict(get_env(credentials))
            auth = base64.b64encode(
                f'{credentials["username"]}:{credentials["password"]}'.encode()
            ).decode("ascii")
            endpoint.headers["Authorization"] = f"Basic {auth}"
        yield endpoint


# see https://github.com/git-lfs/git-lfs/blob/310d1b4a7d01e8d9d884447df4635c7a9c7642c2/docs/api/basic-transfers.md
def get_locations(objects):
    ret = ["local" for _ in objects]
    indexes = [i for i, o in enumerate(objects) if o]
    if not indexes:
        # all objects are local, do not send an empty request as that would be an error
        return ret
    if opts.hash_only:
        for i in indexes:
            ret[i] = objects[i]["oid"]
        return ret
    data = {
        "operation": "download",
        "transfers": ["basic"],
        "objects": [objects[i] for i in indexes],
        "hash_algo": "sha256",
    }
    for endpoint in get_endpoints():
        req = urllib.request.Request(
            f"{endpoint.href}/objects/batch",
            headers=endpoint.headers,
            data=json.dumps(data).encode("ascii"),
        )
        try:
            with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
                data = json.load(resp)
            assert len(data["objects"]) == len(
                indexes
            ), f"received {len(data)} objects, expected {len(indexes)}"
            for i, resp in zip(indexes, data["objects"]):
                ret[i] = f'{resp["oid"]} {resp["actions"]["download"]["href"]}'
            return ret
        except urllib.error.URLError as e:
            warn(f"encountered {type(e).__name__} {e}, ignoring endpoint {endpoint.name}")
            continue
        except KeyError:
            warn(f"encountered malformed response, ignoring endpoint {endpoint.name}:\n{json.dumps(data, indent=2)}")
            continue
    raise NoEndpointsFound


def get_lfs_object(path):
    with open(path, "rb") as fileobj:
        lfs_header = "version https://git-lfs.github.com/spec".encode()
        actual_header = fileobj.read(len(lfs_header))
        sha256 = size = None
        if lfs_header != actual_header:
            return None
        data = dict(get_env(fileobj.read().decode("ascii"), sep=" "))
        assert data["oid"].startswith("sha256:"), f"unknown oid type: {data['oid']}"
        _, _, sha256 = data["oid"].partition(":")
        size = int(data["size"])
        return {"oid": sha256, "size": size}


try:
    objects = [get_lfs_object(src) for src in sources]
    for resp in get_locations(objects):
        print(resp)
except NoEndpointsFound as e:
    print("""\
ERROR: no valid endpoints found, your git authentication method might be currently unsupported by this script.
You can bypass this error by running from semmle-code (this might take a while):
  git config lfs.fetchexclude ""
  git -C ql config lfs.fetchinclude \\*
  git lfs fetch && git lfs checkout
  cd ql
  git lfs fetch && git lfs checkout""", file=sys.stderr)
    sys.exit(1)
