/**
 * @name Dynamic allocation after initialization
 * @description Dynamic memory allocation (using malloc() or calloc()) should be confined to the initialization routines of a program.
 * @kind problem
 * @id cpp/power-of-10/dynamic-alloc-after-init
 * @problem.severity recommendation
 * @tags resources
 *       external/powerof10
 */

import cpp

class Initialization extends Function {
  Initialization() {
    // Adapt this query to your codebase by changing this predicate to match
    // precisely what functions count as "initialization", and are, hence,
    // allowed to perform dynamic memory allocation.
    this.getName().toLowerCase().matches("init%") or
    this.getName().matches("%\\_init")
  }
}

class Allocation extends FunctionCall {
  Allocation() {
    exists(string name | name = this.getTarget().getName() | name = "malloc" or name = "calloc")
  }
}

from Function f, Allocation a
where
  not f instanceof Initialization and
  a.getEnclosingFunction() = f
select a, "Dynamic memory allocation is only allowed during initialization."
