from .module \
import module

from . import module2 as module3
module2 = 7
from . import module2 as module4
from . import module3 as module5
from code.package import moduleX

#We should now have:
#module2 = 7
#module3 = package.module2
#module4 = 7
#module5 = package.module2
#moduleX = package.moduleX
