Writing CodeQL queries for Kotlin versus Java analysis
------------------------------------------------------

Generally you use the same classes to write queries for Kotlin and for Java. You use the same libraries such as DataFlow, TaintTracking, or SSA, and the same classes such as ``MethodAccess`` or ``Class`` for both languages. When you want to access Kotlin-specific elements (such as a ``WhenExpr``) you’ll need to use Kotlin-specific CodeQL classes.

There are however some important cases where writing queries for Kotlin can produce surprising results compared to writing queries for Java, as CodeQL works with the JVM bytecode representation of the Kotlin source code. 

Be careful when you model code elements that don’t exist in Java, such as ``NotNullExpr (expr!!)``, because they could interact in unexpected ways with common predicates. For example, ``MethodAccess.getQualifier()`` returns a ``NotNullExpr`` instead of a ``VarAccess`` in the following Kotlin code:

.. code-block:: kotlin
   
   someVar!!.someMethodCall()

In that specific case, you can use the predicate ``Expr.getUnderlyingExpr()``. This goes directly to the underlying ``VarAccess`` to produce a more similar behavior to that in Java.

Nullable elements (``?``) can also produce unexpected behavior. To avoid a ``NullPointerException``, Kotlin may inline calls like ``expr.toString()`` to ``String.valueOf(expr)`` when ``expr`` is nullable. Make sure that you write CodeQL around the extracted code, which may not exactly match the code as written in the codebase.

Another example is that if-else expressions in Kotlin are translated into ``WhenExprs`` in CodeQL, instead of the more typical ``IfStmt`` seen in Java.

In general, you can debug these issues with the AST (you can use the ``CodeQL: View AST`` command from Visual Studio Code’s CodeQL extension, or run the ``PrintAst.ql`` query) and see exactly what CodeQL is extracting from your code.