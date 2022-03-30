import cpp

from Class c, string n
where n = count(Class x | x.getName() = c.getName()) + " distinct class(es) called " + c.getName()
select c, n
