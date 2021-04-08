import python
import Expressions.Formatting.AdvancedFormatting

from AdvancedFormatString a, string name, int start, int end
where
  name = "'" + a.getFieldName(start, end) + "'"
  or
  name = a.getFieldNumber(start, end).toString()
select a.getLocation().getStartLine(), a.getText(), start, end, name
