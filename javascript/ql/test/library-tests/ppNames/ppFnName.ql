import javascript

query string getInferredName(Function f) {
  result = f.getInferredName()
}

from Function f
select f, f.describe()
