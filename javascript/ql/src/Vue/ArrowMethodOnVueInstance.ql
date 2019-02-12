/**
 * @name Arrow method on Vue instance
 * @description An arrow method on a Vue instance doesn't have its `this` variable bound to the Vue instance.
 * @kind problem
 * @problem.severity warning
 * @id js/vue/arrow-method-on-vue-instance
 * @tags reliability
 *       frameworks/vue
 * @precision high
 */

import javascript

from Vue::Instance instance, DataFlow::Node def, DataFlow::FunctionNode arrow, ThisExpr dis
where
  instance.getABoundFunction() = def and
  arrow.flowsTo(def) and
  arrow.asExpr() instanceof ArrowFunctionExpr and
  arrow.asExpr() = dis.getEnclosingFunction()
select def, "The $@ of this $@ it will not be bound to the Vue instance.", dis, "`this` variable",
  arrow, "arrow function"
