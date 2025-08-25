=======================
Exercise: Apache Struts
=======================

.. container:: subheading

   Unsafe deserialization leading to an RCE

   CVE-2017-9805

.. rst-class:: setup

Setup
=====

For this example you need to set up `CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__ and download the CodeQL database for `Apache Struts <https://github.com/apache/struts>`__ from GitHub.

Unsafe deserialization in Struts
================================

Apache Struts provides a ``ContentTypeHandler`` interface, which can be implemented for specific content types. It defines the following interface method:

.. code-block:: java

  void toObject(Reader in, Object target);


which is intended to populate the ``target`` object with data from the reader, usually through deserialization. However, the ``in`` parameter should be considered untrusted, and should not be deserialized without sanitization.

RCE in Apache Struts
====================

- Vulnerable code looked like this:

   .. code-block:: java
   
      public void toObject(Reader in, Object target) {
        XStream xstream = createXStream();
        xstream.fromXML(in, target);
      }

- Xstream allows deserialization of **dynamic proxies**, which permit remote code execution.

- Disclosed as `CVE-2017-9805 <http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9805>`__

- Blog post: https://securitylab.github.com/research/apache-struts-vulnerability-cve-2017-9805

Finding the RCE yourself
========================

#. Create a class to find the interface ``org.apache.struts2.rest.handler.ContentTypeHandler``

   **Hint**: Use predicate ``hasQualifiedName(...)``

#. Identify methods called ``toObject``, which are defined on direct subtypes of ``ContentTypeHandler``

   **Hint**: Use ``Method.getDeclaringType()`` and ``Type.getASupertype()``

#. Implement a ``DataFlow::ConfigSig``, defining the source as the first parameter of a ``toObject`` method, and the sink as an instance of ``UnsafeDeserializationSink``.

   **Hint**: Use ``Node::asParameter()``

#. Construct the query as a path-problem query, and verify you find one result.

Model answer, step 1
====================

.. code-block:: ql

  import java

  /** The interface `org.apache.struts2.rest.handler.ContentTypeHandler`. */

  class ContentTypeHandler extends RefType {
    ContentTypeHandler() {
      this.hasQualifiedName("org.apache.struts2.rest.handler", "ContentTypeHandler")
    }
  }

Model answer, step 2
====================

.. code-block:: ql

   /** A `toObject` method on a subtype of `org.apache.struts2.rest.handler.ContentTypeHandler`. */
   class ContentTypeHandlerDeserialization extends Method {
     ContentTypeHandlerDeserialization() {
       this.getDeclaringType().getASupertype() instanceof ContentTypeHandler and
       this.hasName("toObject")

Model answer, step 3
====================

.. code-block:: ql

   import UnsafeDeserialization
   import semmle.code.java.dataflow.DataFlow::DataFlow
   /**
    * Configuration that tracks the flow of taint from the first parameter of
    * `ContentTypeHandler.toObject` to an instance of unsafe deserialization.
    */
   module StrutsUnsafeDeserializationConfig implements ConfigSig {
     predicate isSource(Node source) {
       source.asParameter() = any(ContentTypeHandlerDeserialization des).getParameter(0)
     }
     predicate isSink(Node sink) { sink instanceof UnsafeDeserializationSink }
   }
   module StrutsUnsafeDeserializationFlow = Global<StrutsUnsafeDeserializationConfig>;

Model answer, step 4
====================

.. code-block:: ql

   import PathGraph
   ...
   from PathNode source, PathNode sink
   where StrutsUnsafeDeserializationFlow::flowPath(source, sink)
   select sink.getNode().(UnsafeDeserializationSink).getMethodAccess(), source, sink, "Unsafe deserialization of $@.", source, "user input"

More full-featured version: https://github.com/github/securitylab/tree/main/CodeQL_Queries/java/Apache_Struts_CVE-2017-9805
