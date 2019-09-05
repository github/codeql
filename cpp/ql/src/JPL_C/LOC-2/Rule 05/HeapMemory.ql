/**
 * @name Dynamic allocation after initialization
 * @description Dynamic memory allocation (using malloc() or calloc()) should be confined to the initialization routines of a program.
 * @kind problem
 * @id cpp/jpl-c/heap-memory
 * @problem.severity recommendation
 * @tags resources
 *       external/jpl
 */

import cpp

class Initialization extends Function {
  Initialization() {
    // TODO: This could be refined to match precisely what functions count
    // as "initialization", and are, hence, allowed to perform dynamic
    // memory allocation.
    this.getName().toLowerCase().matches("init%") or
    this.getName().toLowerCase().matches("%\\_init")
  }
}

class Allocation extends FunctionCall {
  Allocation() {
    exists(string name | name = this.getTarget().getName() |
      name = "malloc" or
      name = "calloc" or
      name = "alloca" or
      name = "sbrk" or
      name = "valloc"
    )
  }
}

from Function f, Allocation a
where
  not f instanceof Initialization and
  a.getEnclosingFunction() = f
select a, "Dynamic memory allocation is only allowed during initialization."
