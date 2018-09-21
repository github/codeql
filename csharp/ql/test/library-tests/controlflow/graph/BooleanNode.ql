import csharp
import ControlFlow
import Internal
import Nodes

from ElementNode e, BooleanSplit split
where split = e.getASplit()
select split, e
