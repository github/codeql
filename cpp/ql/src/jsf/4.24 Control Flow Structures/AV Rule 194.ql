/**
 * @name AV Rule 194
 * @description All switch statements that do not intend to test for every enumeration value shall contain a final default clause.
 * @kind problem
 * @id cpp/jsf/av-rule-194
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

from EnumSwitch es, EnumConstant ec
where
  // A switch without a default case ...
  not es.hasDefaultCase() and
  // ... that misses at least one value ...
  ec = es.getAMissingCase() and
  // ... and make sure we pick a single missed value; choose the first one
  not exists(EnumConstant ec2, int i, int j |
    ec2 = es.getAMissingCase() and
    ec2 = ec2.getDeclaringEnum().getEnumConstant(i) and
    ec = ec.getDeclaringEnum().getEnumConstant(j) and
    i < j
  )
select es,
  "AV Rule 195: all switch statements that do not intend to test for every enumeration value shall contain a final default clause. This statement is missing a case for "
    + ec.getName()
