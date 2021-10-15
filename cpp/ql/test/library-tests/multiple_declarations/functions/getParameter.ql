import cpp

from Function f, int i
where f.getName() = "f"
select i, f.getParameter(i), count(f.getParameter(i)), count(f.getParameter(i).getType())
