function foo() {
  let source = source();
  
  const changeCase = require("change-case");
  sink(changeCase.camelCase(source)); // NOT OK

}
