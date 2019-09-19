import cpp

from File f, Declaration d
where
  d = f.getATopLevelDeclaration() and
  d.getName() != "__va_list_tag"
select f.toString(), d
