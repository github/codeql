class Type_ extends @type {
  string toString() { result = "Type" }
}

/**
 * A new kind has been inserted such that `@arraytype` which used to have index
 * 26 now has index 27. Another new kind has been inserted at 39, which is the
 * end of the list. Entries with lower indices are unchanged.
 */
bindingset[new_index]
int old_index(int new_index) {
  if new_index < 26
  then result = new_index
  else
    if new_index = 26
    then result = 0 // invalidtype
    else
      if new_index < 39
      then result + (27 - 26) = new_index
      else result = 0 // invalidtype
}

// The schema for types is:
//
// types(unique int id: @type,
//     int kind: int ref);
from Type_ type, int new_kind, int old_kind
where
  types(type, new_kind) and
  old_kind = old_index(new_kind)
select type, old_kind
