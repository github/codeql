import python
import Expressions.Formatting.AdvancedFormatting

from AdvancedFormatString a, int start, int end
select a.getLocation().getStartLine(), a.getText(), start, end, a.getField(start, end)
