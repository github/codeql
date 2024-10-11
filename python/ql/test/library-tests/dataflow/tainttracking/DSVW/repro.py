import re
import urllib.parse
import sys
import http.client

def generator_dict_re_combo():
    query = TAINTED_STRING

    params = dict(
            (
                match.group("parameter"),
                urllib.parse.unquote(
                    ",".join(
                        re.findall(
                            r"(?:\A|[?&])%s=([^&]+)" % match.group("parameter"), query
                        )
                    )
                ),
            )
            for match in re.finditer(
                r"((\A|[?&])(?P<parameter>[\w\[\]]+)=)([^&]+)", query
            )
        )

    ensure_tainted(params) # $ tainted

def parse_qs():
    query = TAINTED_STRING

    params = urllib.parse.parse_qs(query)

    ensure_tainted(params) # $ tainted

HTML_PREFIX = """<!DOCTYPE html>"""

def flat():
    self_path = TAINTED_STRING

    path, query = self_path.split('?', 1) if '?' in self_path else (self_path, "")
    code, content, params, cursor = http.client.OK, HTML_PREFIX, dict((match.group("parameter"), urllib.parse.unquote(','.join(re.findall(r"(?:\A|[?&])%s=([^&]+)" % match.group("parameter"), query)))) for match in re.finditer(r"((\A|[?&])(?P<parameter>[\w\[\]]+)=)([^&]+)", query)), "Cursor"
    
    print(code)
    print(content)
    ensure_tainted(params) # $ tainted
    print(cursor)
