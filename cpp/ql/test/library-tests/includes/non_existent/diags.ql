import cpp

from Diagnostic d
select d.getLocation().toString(), d.getSeverity(), d.getTag(), d.getMessage(), d.getFullMessage()
