import php
import codeql.php.DataFlow

from DataFlowNode n
select n, n.toString()
