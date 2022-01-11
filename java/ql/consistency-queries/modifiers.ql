import java

from string mod, Location l
where
  diagnostics(_, _, _, _, "Unexpected visibility: " + mod, _, l) and
  not mod in ["invisible_fake"]
select mod, l
