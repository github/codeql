import csharp

from AssignableRead read1, AssignableRead read2
where read2 = read1.getANextRead()
select read1.getTarget(), read1, read2
