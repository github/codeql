import csharp
import ControlFlow
import ControlFlow::Internal

// Should not have any output; no set of splits should have two representations
from Splits s1, Splits s2
where
  forex(Nodes::Split s | s = s1.getASplit() | s = s2.getASplit()) and
  forex(Nodes::Split s | s = s2.getASplit() | s = s1.getASplit()) and
  s1 != s2
select s1, s2
