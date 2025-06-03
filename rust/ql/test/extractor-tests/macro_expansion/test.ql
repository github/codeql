import rust
import TestUtils

from Item i, MacroItems items, int index, Item expanded
where toBeTested(i) and i.getAttributeMacroExpansion() = items and items.getItem(index) = expanded
select i, index, expanded
