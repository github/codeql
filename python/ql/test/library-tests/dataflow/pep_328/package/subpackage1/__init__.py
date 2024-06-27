from .moduleY import spam
from .moduleY import spam as ham
from . import moduleY
from ..subpackage1 import moduleY
from ..subpackage2.moduleZ import eggs
from ..moduleA import foo

try:
    from ...package import bar
except Exception as e:
    print(e)

try:
    from ...sys import path
except Exception as e:
    print(e)
