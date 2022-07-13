import java

from string genBy, int severity, string tag, string msg, Location l
where
  diagnostics(_, genBy, severity, tag, msg, _, l) and
  (
    // Different installations get different sets of these messages,
    // so we filter out all but one that happens everywhere.
    msg.matches("Not rewriting trap file for: %")
    implies
    msg.matches("Not rewriting trap file for: Boolean %")
  )
select genBy, severity, tag, msg, l
