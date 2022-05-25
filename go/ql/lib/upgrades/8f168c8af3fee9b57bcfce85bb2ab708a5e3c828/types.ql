class Type_ extends @type {
  string toString() { result = "Type" }
}

/**
 * A new kind has been inserted such that `@arraytype` which used to have index
 * 26 now has index 27. Another new kind has been inserted at 39, which is the
 * end of the list. Entries with lower indices are unchanged.
 */
bindingset[old_index]
int new_index(int old_index) {
  if old_index < 26 then result = old_index else result = (27 - 26) + old_index
}

// The schema for types is:
//
// types(unique int id: @type,
//     int kind: int ref);
from Type_ type, int new_kind, int old_kind
where types(type, old_kind) and new_kind = new_index(old_kind)
select type, new_kind
