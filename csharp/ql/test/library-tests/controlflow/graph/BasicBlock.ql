import csharp
import semmle.code.csharp.controlflow.BasicBlocks

from BasicBlock bb
select
  bb.getFirstNode(),
  bb.getLastNode(),
  bb.length()
