.. _navigating-the-call-graph:

Navigating the call graph
=========================

CodeQL has classes for identifying code that calls other code, and code that can be called from elsewhere. This allows you to find, for example, methods that are never used.

Call graph classes
------------------

The CodeQL library for Java provides two abstract classes for representing a program's call graph: ``Callable`` and ``Call``. The former is simply the common superclass of ``Method`` and ``Constructor``, the latter is a common superclass of ``MethodAccess``, ``ClassInstanceExpression``, ``ThisConstructorInvocationStmt`` and ``SuperConstructorInvocationStmt``. Simply put, a ``Callable`` is something that can be invoked, and a ``Call`` is something that invokes a ``Callable``.

For example, in the following program all callables and calls have been annotated with comments:

.. code-block:: java

   class Super {
       int x;

       // callable
       public Super() {
           this(23);       // call
       }

       // callable
       public Super(int x) {
           this.x = x;
       }

       // callable
       public int getX() {
           return x;
       }
   }

       class Sub extends Super {
       // callable
       public Sub(int x) {
           super(x+19);    // call
       }

       // callable
       public int getX() {
           return x-19;
       }
   }

   class Client {
       // callable
       public static void main(String[] args) {
           Super s = new Sub(42);  // call
           s.getX();               // call
       }
   }

Class ``Call`` provides two call graph navigation predicates:

-  ``getCallee`` returns the ``Callable`` that this call (statically) resolves to; note that for a call to an instance (that is, non-static) method, the actual method invoked at runtime may be some other method that overrides this method.
-  ``getCaller`` returns the ``Callable`` of which this call is syntactically part.

For instance, in our example ``getCallee`` of the second call in ``Client.main`` would return ``Super.getX``. At runtime, though, this call would actually invoke ``Sub.getX``.

Class ``Callable`` defines a large number of member predicates; for our purposes, the two most important ones are:

-  ``calls(Callable target)`` succeeds if this callable contains a call whose callee is ``target``.
-  ``polyCalls(Callable target)`` succeeds if this callable may call ``target`` at runtime; this is the case if it contains a call whose callee is either ``target`` or a method that ``target`` overrides.

In our example, ``Client.main`` calls the constructor ``Sub(int)`` and the method ``Super.getX``; additionally, it ``polyCalls`` method ``Sub.getX``.

Example: Finding unused methods
-------------------------------

We can use the ``Callable`` class to write a query that finds methods that are not called by any other method:

.. code-block:: ql

   import java

   from Callable callee
   where not exists(Callable caller | caller.polyCalls(callee))
   select callee

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8376915232270534450/>`__. This simple query typically returns a large number of results.

.. pull-quote::

   Note

   We have to use ``polyCalls`` instead of ``calls`` here: we want to be reasonably sure that ``callee`` is not called, either directly or via overriding.

Running this query on a typical Java project results in lots of hits in the Java standard library. This makes sense, since no single client program uses every method of the standard library. More generally, we may want to exclude methods and constructors from compiled libraries. We can use the predicate ``fromSource`` to check whether a compilation unit is a source file, and refine our query:

.. code-block:: ql

   import java

   from Callable callee
   where not exists(Callable caller | caller.polyCalls(callee)) and
       callee.getCompilationUnit().fromSource()
   select callee, "Not called."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8711624074465690976/>`__. This change reduces the number of results returned for most projects.

We might also notice several unused methods with the somewhat strange name ``<clinit>``: these are class initializers; while they are not explicitly called anywhere in the code, they are called implicitly whenever the surrounding class is loaded. Hence it makes sense to exclude them from our query. While we are at it, we can also exclude finalizers, which are similarly invoked implicitly:

.. code-block:: ql

   import java

   from Callable callee
   where not exists(Callable caller | caller.polyCalls(callee)) and
       callee.getCompilationUnit().fromSource() and
       not callee.hasName("<clinit>") and not callee.hasName("finalize")
   select callee, "Not called."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/925473733866047471/>`__. This also reduces the number of results returned by most projects.

We may also want to exclude public methods from our query, since they may be external API entry points:

.. code-block:: ql

   import java

   from Callable callee
   where not exists(Callable caller | caller.polyCalls(callee)) and
       callee.getCompilationUnit().fromSource() and
       not callee.hasName("<clinit>") and not callee.hasName("finalize") and
       not callee.isPublic()
   select callee, "Not called."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/6284320987237954610/>`__. This should have a more noticeable effect on the number of results returned.

A further special case is non-public default constructors: in the singleton pattern, for example, a class is provided with private empty default constructor to prevent it from being instantiated. Since the very purpose of such constructors is their not being called, they should not be flagged up:

.. code-block:: ql

   import java

   from Callable callee
   where not exists(Callable caller | caller.polyCalls(callee)) and
       callee.getCompilationUnit().fromSource() and
       not callee.hasName("<clinit>") and not callee.hasName("finalize") and
       not callee.isPublic() and
       not callee.(Constructor).getNumberOfParameters() = 0
   select callee, "Not called."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2625028545869146918/>`__. This change has a large effect on the results for some projects but little effect on the results for others. Use of this pattern varies widely between different projects.

Finally, on many Java projects there are methods that are invoked indirectly by reflection. So, while there are no calls invoking these methods, they are, in fact, used. It is in general very hard to identify such methods. A very common special case, however, is JUnit test methods, which are reflectively invoked by a test runner. The CodeQL library for Java has support for recognizing test classes of JUnit and other testing frameworks, which we can employ to filter out methods defined in such classes:

.. code-block:: ql

   import java

   from Callable callee
   where not exists(Callable caller | caller.polyCalls(callee)) and
       callee.getCompilationUnit().fromSource() and
       not callee.hasName("<clinit>") and not callee.hasName("finalize") and
       not callee.isPublic() and
       not callee.(Constructor).getNumberOfParameters() = 0 and
       not callee.getDeclaringType() instanceof TestClass
   select callee, "Not called."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2055862421970264112/>`__. This should give a further reduction in the number of results returned.

Further reading
---------------

.. include:: ../reusables/java-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
