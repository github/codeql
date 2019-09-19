/**
 * @name Constructor with default arguments will be used as a copy constructor
 * @description Constructors with default arguments should not be signature-compatible with a copy constructor when their default arguments are taken into account.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/constructor-used-as-copy-constructor
 * @tags reliability
 *       readability
 *       language-features
 *       external/jsf
 */

import cpp

from CopyConstructor f
where
  f.getNumberOfParameters() > 1 and
  not f.mayNotBeCopyConstructorInInstantiation()
select f,
  f.getName() +
    " is signature-compatible with a copy constructor when its default arguments are taken into account."
