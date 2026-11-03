from flask import request # $ Source
import re
from re import prefixmatch as prefix_match


def direct():
    pattern = request.args["pattern"]
    re.prefixmatch(pattern, "safe") # $ Alert


def direct_keywords():
    pattern = request.args["pattern"]
    re.prefixmatch(pattern=pattern, string="safe") # $ Alert


def imported_alias():
    pattern = request.args["pattern"]
    prefix_match(pattern, "safe") # $ Alert


def compiled():
    pattern = request.args["pattern"]
    compiled_pattern = re.compile(pattern) # $ Alert
    compiled_pattern.prefixmatch("safe")


def compiled_keywords():
    pattern = request.args["pattern"]
    compiled_pattern = re.compile(pattern=pattern) # $ Alert
    compiled_pattern.prefixmatch(string="safe", pos=0, endpos=4)
