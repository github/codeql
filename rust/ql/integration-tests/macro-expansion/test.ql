import rust

from Item i, MacroItems items, int index, Item expanded
where i.getAttributeMacroExpansion() = items and items.getItem(index) = expanded
select i, index, expanded
