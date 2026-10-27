from flask import request # $ Source
import re
import requests


def direct():
    path = request.args["path"]
    if re.prefixmatch(r"[a-zA-Z0-9]+\Z", path):
        requests.get(f"https://example.com/{path}")
    else:
        requests.get(f"https://example.com/{path}") # $ Alert[py/partial-ssrf]


def direct_keywords():
    url = request.args["url"]
    if re.prefixmatch(pattern=r"https://example\.com/[a-zA-Z0-9]+\Z", string=url):
        requests.get(url)
    else:
        requests.get(url) # $ Alert[py/full-ssrf]


def compiled():
    url = request.args["url"]
    pattern = re.compile(r"https://example\.com/[a-zA-Z0-9]+\Z")
    if pattern.prefixmatch(url):
        requests.get(url)
    else:
        requests.get(url) # $ Alert[py/full-ssrf]


def compiled_keywords():
    path = request.args["path"]
    pattern = re.compile(r"[a-zA-Z0-9]+\Z")
    if pattern.prefixmatch(string=path):
        requests.get(f"https://example.com/{path}")
    else:
        requests.get(f"https://example.com/{path}") # $ Alert[py/partial-ssrf]
