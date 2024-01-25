import python
import analysis.DefinitionTracking

from NiceLocationExpr expr, string f, int bl, int bc, int el, int ec
where expr.hasLocationInfo(f, bl, bc, el, ec)
select f, bl, bc, el, ec
