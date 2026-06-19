# there should be no difference whether you import 2 things on 1 line, or use 2
# lines
from typing import Optional

from unknown import foo
from unknown import bar

var: Optional['foo'] = None
