import re
matcher = re.compile(r"\b[\t\b]")

def match_data(data):
    return bool(matcher.match(data))
