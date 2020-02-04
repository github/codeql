/**
 * @name Inconsistent definition of copy constructor and assignment ('Rule of Two')
 * @description Classes that have an explicit copy constructor or copy
 *              assignment operator may behave inconsistently if they do
 *              not have both.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/rule-of-two
 * @tags reliability
 *       readability
 *       language-features
 */

import cpp

// This query enforces the Rule of Two, which is a conservative variation of
// the more well-known Rule of Three.
//
// The Rule of Two is usually phrased informally, ignoring the distinction
// between whether a member is missing because it's auto-generated (missing
// from the source) or missing because it can't be called (missing from the
// generated code).
//
// This query checks if one member is explicitly defined while the other is
// auto-generated. This can lead to memory safety issues. It's a separate issue
// whether one is callable while the other is not callable; that is an API
// design question and carries has no safety risk.
predicate generatedCopyAssignment(CopyConstructor cc, string msg) {
  cc.getDeclaringType().hasImplicitCopyAssignmentOperator() and
  msg =
    "No matching copy assignment operator in class " + cc.getDeclaringType().getName() +
      ". It is good practice to match a copy constructor with a " + "copy assignment operator."
}

predicate generatedCopyConstructor(CopyAssignmentOperator ca, string msg) {
  ca.getDeclaringType().hasImplicitCopyConstructor() and
  msg =
    "No matching copy constructor in class " + ca.getDeclaringType().getName() +
      ". It is good practice to match a copy assignment operator with a " + "copy constructor."
}

from MemberFunction f, string msg
where
  (
    generatedCopyAssignment(f, msg) or
    generatedCopyConstructor(f, msg)
  ) and
  // Ignore template instantiations to prevent an explosion of alerts
  not f.getDeclaringType().isConstructedFrom(_) and
  // Ignore private members since a private constructor or assignment operator
  // is a common idiom that simulates suppressing the default-generated
  // members. It would be better to use C++11's "delete" facility or use
  // appropriate Boost helper classes, but it is too common to report as a
  // violation.
  not f.isPrivate() and
  // If it is truly user-defined then it must have a body. This leaves out
  // C++11 members that use `= delete` or `= default`.
  exists(f.getBlock()) and
  // In rare cases, the extractor pretends that an auto-generated copy
  // constructor has a block that is one character long and is located on top
  // of the first character of the class name. Checking for
  // `isCompilerGenerated` will remove those results.
  not f.isCompilerGenerated() and
  not f.isDeleted()
select f, msg
