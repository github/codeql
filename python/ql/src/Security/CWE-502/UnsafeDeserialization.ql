/**
 * @name Deserializing untrusted input
 * @description Deserializing user-controlled data may allow attackers to execute arbitrary code.
 * @kind path-problem
 * @id py/unsafe-deserialization
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-502
 *       security
 *       serialization
 */
import python

// Sources -- Any untrusted input
import semmle.python.web.HttpRequest
import semmle.python.security.Paths

// Flow -- untrusted string
import semmle.python.security.strings.Untrusted

// Sink -- Unpickling and other deserialization formats.
import semmle.python.security.injection.Pickle
import semmle.python.security.injection.Marshal
import semmle.python.security.injection.Yaml


from TaintedNode srcnode, TaintedNode sinknode, TaintSource src, TaintSink sink
where src.flowsToSink(sink) and srcnode.getNode() = src and sinknode.getNode() = sink

select sink, srcnode, sinknode, "Deserializing of $@.", src, "untrusted input"
