import javascript

query string getName(ClassDefinition c) { result = c.getName() }

from ClassDefinition c
select c, c.describe()
