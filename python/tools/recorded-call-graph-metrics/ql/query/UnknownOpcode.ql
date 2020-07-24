import python
import lib.RecordedCalls

// Could be useful for deciding which new opcodes to support
from string op_name, int c
where
  exists(XMLBytecodeUnknown unknown | unknown.get_opname_data() = op_name) and
  c = count(XMLBytecodeUnknown unknown | unknown.get_opname_data() = op_name | 1)
select op_name, c order by c
