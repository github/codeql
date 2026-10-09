import re
from re import prefixmatch as prefix_match

ts = TAINTED_STRING
pat = r"(?P<key>.*)"
compiled_pat = re.compile(pat)

ensure_tainted(
    re.prefixmatch(pat, ts), # $ tainted
    re.prefixmatch(pattern=pat, string=ts), # $ tainted
    prefix_match(pat, ts), # $ tainted
    compiled_pat.prefixmatch(ts), # $ tainted
    compiled_pat.prefixmatch(string=ts, pos=0, endpos=10), # $ tainted

    re.prefixmatch(pat, ts).string, # $ tainted
    re.prefixmatch(ts, "safe").re.pattern, # $ tainted
    compiled_pat.prefixmatch(ts).string, # $ tainted
    re.compile(ts).prefixmatch("safe").re.pattern, # $ tainted
)

direct_match = re.prefixmatch(pat, ts)
compiled_match = compiled_pat.prefixmatch(ts)
ensure_tainted(
    direct_match.group(), # $ tainted
    direct_match.groups()[0], # $ tainted
    direct_match.groupdict()["key"], # $ tainted
    direct_match[0], # $ tainted
    direct_match["key"], # $ tainted
    direct_match.expand(r"\1"), # $ tainted

    compiled_match.group(), # $ tainted
    compiled_match.groups()[0], # $ tainted
    compiled_match.groupdict()["key"], # $ tainted
    compiled_match[0], # $ tainted
    compiled_match["key"], # $ tainted
    compiled_match.expand(r"\1"), # $ tainted
)

ensure_not_tainted(
    re.prefixmatch(pat, "safe").string,
    re.prefixmatch(pat, ts).re.pattern,
    re.prefixmatch(ts, "safe").group(),
    compiled_pat.prefixmatch("safe").string,
    compiled_pat.prefixmatch(ts).re.pattern,
    re.compile(ts).prefixmatch("safe").group(),
)
