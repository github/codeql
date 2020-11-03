#!/usr/bin/env python
from __future__ import unicode_literals

"""
This script employs a VERY basic heuristic ('porn' in webpage.lower()) to check
if we are not 'age_limit' tagging some porn site

A second approach implemented relies on a list of porn domains, to activate it
pass the list filename as the only argument
"""

# Allow direct execution
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from test.helper import gettestcases
from youtube_dl.utils import compat_urllib_parse_urlparse
from youtube_dl.utils import compat_urllib_request

if len(sys.argv) > 1:
    METHOD = 'LIST'
    LIST = open(sys.argv[1]).read().decode('utf8').strip()
else:
    METHOD = 'EURISTIC'

for test in gettestcases():
    if METHOD == 'EURISTIC':
        try:
            webpage = compat_urllib_request.urlopen(test['url'], timeout=10).read()
        except Exception:
            print('\nFail: {0}'.format(test['name']))
            continue

        webpage = webpage.decode('utf8', 'replace')

        RESULT = 'porn' in webpage.lower()

    elif METHOD == 'LIST':
        domain = compat_urllib_parse_urlparse(test['url']).netloc
        if not domain:
            print('\nFail: {0}'.format(test['name']))
            continue
        domain = '.'.join(domain.split('.')[-2:])

        RESULT = ('.' + domain + '\n' in LIST or '\n' + domain + '\n' in LIST)

    if RESULT and ('info_dict' not in test or 'age_limit' not in test['info_dict']
                   or test['info_dict']['age_limit'] != 18):
        print('\nPotential missing age_limit check: {0}'.format(test['name']))

    elif not RESULT and ('info_dict' in test and 'age_limit' in test['info_dict']
                         and test['info_dict']['age_limit'] == 18):
        print('\nPotential false negative: {0}'.format(test['name']))

    else:
        sys.stdout.write('.')
    sys.stdout.flush()

print()
