import java

from string genBy, int severity, string tag, string msg, Location l
where diagnostics(_, genBy, severity, tag, msg, _, l)
select genBy, severity, tag, msg, l
