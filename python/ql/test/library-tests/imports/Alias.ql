import python

from Alias a, ImportMember i
where i = a.getValue()
select a.toString(), i.getName(), a.getAsname().toString()
