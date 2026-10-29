import sys

import six.moves.urllib_error as error
import six.moves.urllib_parse as parse
import six.moves.urllib_request as request
import six.moves.urllib_response as response
import six.moves.urllib_robotparser as robotparser

sys.modules['six.moves.urllib.error'] = error
sys.modules['six.moves.urllib.parse'] = parse
sys.modules['six.moves.urllib.request'] = request
sys.modules['six.moves.urllib.response'] = response
sys.modules['six.moves.urllib.robotparser'] = robotparser

del sys
