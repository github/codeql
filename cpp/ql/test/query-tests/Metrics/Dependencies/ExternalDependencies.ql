import TestPackage

// this is a copy of the body of ExternalDependencies.ql
from File file, int num, string encodedDependency
where encodedDependencies(file, encodedDependency, num)
select encodedDependency, num order by num desc
