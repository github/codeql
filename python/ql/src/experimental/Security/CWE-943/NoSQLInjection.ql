/**
 * @name NoSQL Injection
 * @description Building a NoSQL query from user-controlled sources is vulnerable to insertion of
 *              malicious NoSQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id python/nosql-injection
 * @tags experimental
 *       security
 *       external/cwe/cwe-943
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
// https://ghsecuritylab.slack.com/archives/CQJU6RN49/p1617022135088100
import semmle.python.dataflow.new.TaintTracking2
import DataFlow::PathGraph
// from, where, select statements
