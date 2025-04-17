import rust
import TestUtils

from Item i, MacroItems items, Item expanded
where toBeTested(i) and i.getExpanded() = items and items.getAnItem() = expanded
select i, expanded
