import cpp

from Declaration d
where d.getName() != "__va_list_tag"
select d
