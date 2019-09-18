import cpp

from Class c
where c.getName() != "__va_list_tag"
select c, c.getMetrics().getNestingLevel()
