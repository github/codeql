/**
 * @name Number of distinct conditions used in #if, #ifdef, #ifndef etc. per file
 * @description For each file, the number of unique conditions used by
 *              `#if`, `#ifdef`, and `#ifndef`.
 * @kind treemap
 * @id cpp/conditional-segment-conditions
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       readability
 */

import cpp

predicate preprocessorOpenCondition(PreprocessorDirective d) {
  d instanceof PreprocessorIf or
  d instanceof PreprocessorIfdef or
  d instanceof PreprocessorIfndef
}

predicate headerGuard(PreprocessorIfndef notdef) {
  notdef.getHead().regexpMatch(".*_H_.*")
  or
  notdef.getHead().regexpMatch(".*_H")
}

from File f
where f.fromSource()
select f,
  count(string s |
    exists(PreprocessorDirective open |
      preprocessorOpenCondition(open) and
      not headerGuard(open) and
      open.getFile() = f and
      s = open.getHead()
    )
  )
