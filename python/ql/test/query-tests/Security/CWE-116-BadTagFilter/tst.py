import re

filters = [
    re.compile(r"""<script.*?>.*?<\/script>""", re.IGNORECASE), # NOT OK - doesn't match newlines or `</script >`
    re.compile(r"""<script.*?>.*?<\/script>""", re.IGNORECASE | re.DOTALL), # NOT OK - doesn't match `</script >`
    re.compile(r"""<script.*?>.*?<\/script[^>]*>""", re.IGNORECASE | re.DOTALL), # OK
    re.compile(r"""<!--.*-->""", re.IGNORECASE | re.DOTALL), # OK - we don't care regexps that only match comments
    re.compile(r"""<!--.*--!?>""", re.IGNORECASE | re.DOTALL), # OK
    re.compile(r"""<!--.*--!?>""", re.IGNORECASE), # NOT OK, does not match newlines
    re.compile(r"""(?is)<!--.*--!?>"""), # OK
    re.compile(r"""(?i)<!--.*--!?>"""), # NOT OK, does not match newlines [NOT DETECTED]
    re.compile(r"""<script.*?>(.|\s)*?<\/script[^>]*>""", re.IGNORECASE), # NOT OK - doesn't match inside the script tag
    re.compile(r"""<script[^>]*?>.*?<\/script[^>]*>""", re.IGNORECASE), # NOT OK - doesn't match newlines inside the content
    re.compile(r"""<script(\s|\w|=|")*?>.*?<\/script[^>]*>""", re.IGNORECASE | re.DOTALL), # NOT OK - does not match single quotes for attribute values
    re.compile(r"""<script(\s|\w|=|')*?>.*?<\/script[^>]*>""", re.IGNORECASE | re.DOTALL), # NOT OK - does not match double quotes for attribute values
    re.compile(r"""<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>""", re.IGNORECASE | re.DOTALL), # NOT OK - does not match tabs between attributes
    re.compile(r"""<script.*?>.*?<\/script[^>]*>""", re.re.DOTALL), # NOT OK - does not match uppercase SCRIPT tags
    re.compile(r"""<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>""", re.DOTALL), # NOT OK - does not match mixed case script tags
    re.compile(r"""<script[^>]*?>[\s\S]*?<\/script.*>""", re.IGNORECASE), # NOT OK - doesn't match newlines in the end tag
    re.compile(r"""<script[^>]*?>[\s\S]*?<\/script[^>]*?>""", re.IGNORECASE), # OK
    re.compile(r"""<script\b[^>]*>([\s\S]*?)<\/script>""", re.IGNORECASE | re.DOTALL), # NOT OK - too strict matching on the end tag
    re.compile(r"""<(?:!--([\S|\s]*?)-->)|([^\/\s>]+)[\S\s]*?>"""), #// NOT OK - doesn't match comments with the right capture groups
    re.compile(r"""<(?:(?:\/([^>]+)>)|(?:!--([\S|\s]*?)-->)|(?:([^\/\s>]+)((?:\s+[\w\-:.]+(?:\s*=\s*?(?:(?:"[^"]*")|(?:'[^']*')|[^\s"'\/>]+))?)*)[\S\s]*?(\/?)>))"""), # NOT OK - capture groups
	re.compile(r"""(<[a-z\/!$]("[^"]*"|'[^']*'|[^'">])*>|<!(--.*?--\s*)+>)""", re.IGNORECASE), # NOT OK - capture groups
    re.compile(r"""<(?:(?:!--([\w\W]*?)-->)|(?:!\[CDATA\[([\w\W]*?)\]\]>)|(?:!DOCTYPE([\w\W]*?)>)|(?:\?([^\s\/<>]+) ?([\w\W]*?)[?/]>)|(?:\/([A-Za-z][A-Za-z0-9\-_\:\.]*)>)|(?:([A-Za-z][A-Za-z0-9\-_\:\.]*)((?:\s+[^"'>]+(?:(?:"[^"]*")|(?:'[^']*')|[^>]*))*|\/|\s+)>))"""), # NOT OK - capture groups
]

doFilters(filters)
