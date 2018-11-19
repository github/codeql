/**
 * @name Deserializing untrusted input
 * @description Deserializing user-controlled data may allow attackers to execute arbitrary code.
 * @kind problem
 * @id py/unsafe-deserialization
 * @problem.severity error
 * @sub-severity high
 * @precision medium
 * @tags external/cwe/cwe-502
 *       security
 *       serialization
 */
import python

// Sources -- Any untrusted input
import semmle.python.web.HttpRequest

// Flow -- untrusted string
import semmle.python.security.strings.Untrusted

// Sink -- Unpickling and other deserialization formats.
import semmle.python.security.injection.Pickle
import semmle.python.security.injection.Marshal
import semmle.python.security.injection.Yaml

from TaintSource src, TaintSink sink

where src.flowsToSink(sink)

select sink, "Deserializing of $@.", src, "untrusted input"
