import cpp

from Diagnostic d
select d.getLocation(), d.getSeverity(), d.getTag(), d.getMessage(), d.getFullMessage()
