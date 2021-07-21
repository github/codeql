function foo() {
  let source = source();
  
  const changeCase = require("change-case");
  sink(changeCase.camelCase(source)); // NOT OK

  import { camelCase } from "camel-case";
  sink(camelCase(source)); // NOT OK

  var kebabCase = require("kebab-case");
  sink(kebabCase(source)); // NOT OK
  sink(kebabCase.reverse(source)); // NOT OK

  import { titleCase } from "title-case";
  sink(titleCase(source)); // NOT OK

  import titleize from 'titleize';
  sink(titleize(source)); // NOT OK

  const secondCamel = require('camelcase');
  sink(secondCamel(source)); // NOT OK

  const decamelize = require('decamelize');
  sink(decamelize(source)); // NOT OK
}
