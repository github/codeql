import re

# minimal example constructed by @erik-krogh
baz = re.compile(r'\+0')

# examples from LGTM.com
re.compile(r'.*\+0x(?P<offset>[0-9a-f]+)$')
re.compile(r"^\<.*\+0x.*\>$")
re.search(r'^(https?://.*/).+\-0+\.ts$', res, re.MULTILINE)
re.compile('\s+\+0x[0-9a-f]+\s*(.*)')
re.compile("(.*)\+0x([a-f0-9]*)")
LOG_PATTERN = {
    'vumi': re.compile(
        r'(?P<date>[\d\-\:\s]+)\+0000 .* '
        r'Inbound: <Message payload="(?P<message>.*)">'),
    'smpp_inbound': re.compile(
        r'(?P<date>[\d\-\:\s]+)\+0000 .* '
        r'PUBLISHING INBOUND: (?P<message>.*)'),
    'smpp_outbound': re.compile(
        r'(?P<date>[\d\-\:\s]+)\+0000 .* '
        r'Consumed outgoing message <Message payload="(?P<message>.*)">'),
    'dispatcher_inbound_message': re.compile(
        r'(?P<date>[\d\-\:\s]+)\+0000 Processed inbound message for [a-zA-Z0-9_]+: (?P<message>.*)'),
    'dispatcher_outbound_message': re.compile(
        r'(?P<date>[\d\-\:\s]+)\+0000 Processed outbound message for [a-zA-Z0-9_]+: (?P<message>.*)'),
    'dispatcher_event': re.compile(
        r'(?P<date>[\d\-\:\s]+)\+0000 Processed event message for [a-zA-Z0-9_]+: (?P<message>.*)'),
}
re.compile(
      '(.*)(?P<frame>\#[0-9]+ 0x[0-9a-f]{8,16}) '
      '(?P<lib>[^+]+)\+0x(?P<address>[0-9a-f]{8,16})'
      '(?P<symbol_present>)(?P<symbol_name>)')
RE_LINE = re.compile(
        r'(?P<vhost>[^ ]+) '
        r'(?P<ipaddr>[^ ]+) '
        r'(?P<ident>[^ ]+) '
        r'(?P<userid>[^ ]+) '
        r'\[(?P<datetime>[^\]]+) \+0000\] '
        r'"(?P<verb>[^ ]+) /(?P<tool>[^ /?]+)(?P<path>[^ ]*) HTTP/[^"]+" '
        r'(?P<status>\d+) '
        r'(?P<bytes>\d+) '
        r'"(?P<referer>[^"]*)" '
        r'"(?P<ua>[^"]*)"'
        r'(?P<extra>.*)'
    )
re.compile('(?P<frame>\#[0-9]+ 0x[0-9a-f]{8,8}) '
                        '(?P<lib>[^+]+)\+0x(?P<addr>[0-9a-f]{8,8})')
re.compile(
      '(.*)(?P<frame>\#[0-9]+ 0x[0-9a-f]{8,16}) '
      '(?P<lib>[^+]+)\+0x(?P<address>[0-9a-f]{8,16})'
      '(?P<symbol_present>)(?P<symbol_name>)')
re.match(r'^@@ -1.* \+0,0 @@', self.hdr)
re.compile('(.*)(?P<frame>\#[0-9]+ 0x[0-9a-f]{8,16}) '
                               '(?P<lib>[^+]+)\+0x(?P<address>[0-9a-f]{8,16})'
                               '(?P<symbol_present>)(?P<symbol_name>)')
