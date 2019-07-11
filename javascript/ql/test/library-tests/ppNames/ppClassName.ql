import javascript

query string getInferredName(ClassDefinition c) {
  result = c.getInferredName()
}

from ClassDefinition c
select c, c.describe()
