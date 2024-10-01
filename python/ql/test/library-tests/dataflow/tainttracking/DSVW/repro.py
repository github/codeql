import re
import urllib.parse
import sys

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