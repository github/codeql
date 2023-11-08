import re

ts = TAINTED_STRING

pat = ... # some pattern
compiled_pat = re.compile(pat)

# see https://docs.python.org/3/library/re.html#functions
ensure_tainted(
    # returns Match object, see below
    re.search(pat, ts), # $ MISSING: tainted
    re.match(pat, ts), # $ MISSING: tainted
    re.fullmatch(pat, ts), # $ MISSING: tainted

    # other functions not returning Match objects
    re.split(pat, ts), # $ tainted
    re.split(pat, ts)[0], # $ tainted

    re.findall(pat, ts), # $ tainted
    re.findall(pat, ts)[0], # $ tainted

    re.finditer(pat, ts), # $ MISSING: tainted
    [x for x in re.finditer(pat, ts)], # $ tainted

    re.sub(pat, repl="safe", string=ts), # $ tainted
    re.sub(pat, repl=lambda m: ..., string=ts), # $ tainted
    re.sub(pat, repl=ts, string="safe"), # $ tainted
    re.sub(pat, repl=lambda m: ts, string="safe"), # $ tainted

    re.subn(pat, repl="safe", string=ts), # $ MISSING: tainted
    re.subn(pat, repl="safe", string=ts)[0], # $ tainted // the string

    # same for compiled patterns
    compiled_pat.search(ts), # $ MISSING: tainted
    compiled_pat.match(ts), # $ MISSING: tainted
    compiled_pat.fullmatch(ts), # $ MISSING: tainted

    compiled_pat.split(ts), # $ tainted
    compiled_pat.split(ts)[0], # $ tainted

    # ...

    # user-controlled compiled pattern
    re.compile(ts), # $ tainted
    re.compile(ts).pattern, # $ tainted
)

ensure_not_tainted(
    re.subn(pat, repl="safe", string=ts)[1], # // the number of substitutions made
)

# Match object
tainted_match = re.match(pat, ts)
safe_match = re.match(pat, "safe")
ensure_tainted(
    tainted_match.expand("Hello \1"), # $ tainted
    safe_match.expand(ts), # $ tainted
    tainted_match.group(), # $ tainted
    tainted_match.group(1, 2), # $ tainted
    tainted_match.group(1, 2)[0], # $ tainted
    tainted_match[0], # $ tainted
    tainted_match["key"], # $ tainted

    tainted_match.groups(), # $ MISSING: tainted
    tainted_match.groups()[0], # $ tainted
    tainted_match.groupdict(), # $ MISSING: tainted
    tainted_match.groupdict()["key"], # $ tainted

    re.match(pat, ts).string, # $ tainted
    re.match(ts, "safe").re, # $ MISSING: tainted
    re.match(ts, "safe").re.pattern, # $ tainted

    compiled_pat.match(ts).string, # $ tainted
    re.compile(ts).match("safe").re, # $ MISSING: tainted
    re.compile(ts).match("safe").re.pattern, # $ tainted
)
ensure_not_tainted(
    safe_match.expand("Hello \1"),
    safe_match.group(),

    re.match(pat, "safe").re,
    re.match(pat, "safe").string,
)
