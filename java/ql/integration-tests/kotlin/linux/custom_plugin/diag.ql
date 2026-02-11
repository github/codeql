import java

from string genBy, int severity, string tag, string msg, string msg2, Location l
where
  diagnostics(_, genBy, severity, tag, msg, _, l) and
  (
    // Different installations get different sets of these messages,
    // so we filter out all but one that happens everywhere.
    msg.matches("Not rewriting trap file for %")
    implies
    msg.matches("Not rewriting trap file for %Boolean.members%")
  ) and
  msg2 = msg.regexpReplaceAll("#-?[0-9]+\\.-?[0-9]+--?[0-9]+-", "<VERSION>-<MODIFIED>-")
select genBy, severity, tag, msg2, l
