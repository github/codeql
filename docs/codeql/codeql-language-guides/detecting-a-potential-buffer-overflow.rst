.. _detecting-a-potential-buffer-overflow:

Detecting a potential buffer overflow
=====================================

You can use CodeQL to detect potential buffer overflows by checking for allocations equal to ``strlen`` in C and C++. This topic describes how a C/C++ query for detecting a potential buffer overflow was developed.

Problem—detecting memory allocation that omits space for a null termination character
-------------------------------------------------------------------------------------

The objective of this query is to detect C/C++ code which allocates an amount of memory equal to the length of a null terminated string, without adding +1 to make room for a null termination character. For example the following code demonstrates this mistake, and results in a buffer overflow:

.. code-block:: cpp

   void processString(const char *input)
   {
       char *buffer = malloc(strlen(input));

       strcpy(buffer, input);

       ...
   }

Basic query
-----------

Before you can write a query you need to decide what entities to search for and then define how to identify them.

Defining the entities of interest
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You could approach this problem either by searching for code similar to the call to ``malloc`` in line 3 or the call to ``strcpy`` in line 5 (see example above). For our basic query, we start with a simple assumption: any call to ``malloc`` with only a ``strlen`` to define the memory size is likely to cause an error when the memory is populated.

Calls to ``strlen`` can be identified using the library `StrlenCall <https://codeql.github.com/codeql-standard-libraries/cpp/semmle/code/cpp/commons/StringAnalysis.qll/type.StringAnalysis$StrlenCall.html>`__ class, but we need to define a new class to identify calls to ``malloc``. Both the library class and the new class need to extend the standard class ``FunctionCall``, with the added restriction of the function name that they apply to:

.. code-block:: ql

   import cpp

   class MallocCall extends FunctionCall
   {
       MallocCall() { this.getTarget().hasGlobalName("malloc") }
   }

.. pull-quote::
    
   Note

   You could easily extend this class to include similar functions such as ``realloc``, or your own custom allocator. With a little effort they could even include C++ ``new`` expressions (to do this, ``MallocCall`` would need to extend a common superclass of both ``FunctionCall`` and ``NewExpr``, such as ``Expr``).

Finding the ``strlen(string)`` pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before we start to write our query, there's one remaining task. We need to modify our new ``MallocCall`` class, so it returns an expression for the size of the allocation. Currently this will be the first argument to the ``malloc`` call, ``FunctionCall.getArgument(0)``, but converting this into a predicate makes it more flexible for future refinements.

.. code-block:: ql

   class MallocCall extends FunctionCall
   {
       MallocCall() { this.getTarget().hasGlobalName("malloc") }
       Expr getAllocatedSize() {
           result = this.getArgument(0)
       }
   }

Defining the basic query
~~~~~~~~~~~~~~~~~~~~~~~~

Now we can write a query using these classes:

.. code-block:: ql

   import cpp

   class MallocCall extends FunctionCall
   {
       MallocCall() { this.getTarget().hasGlobalName("malloc") }
       Expr getAllocatedSize() {
           result = this.getArgument(0)
       }
   }

   from MallocCall malloc
   where malloc.getAllocatedSize() instanceof StrlenCall
   select malloc, "This allocation does not include space to null-terminate the string."

Note that there is no need to check whether anything is added to the ``strlen`` expression, as it would be in the corrected C code ``malloc(strlen(string) + 1)``. This is because the corrected code would in fact be an ``AddExpr`` containing a ``StrlenCall``, not an instance of ``StrlenCall`` itself. A side-effect of this approach is that we omit certain unlikely patterns such as ``malloc(strlen(string) + 0``). In practice we can always come back and extend our query to cover this pattern if it is a concern.

.. pull-quote::

   Tip

   For some projects, this query may not return any results. Possibly the project you are querying does not have any problems of this kind, but it is also important to make sure the query itself is working properly. One solution is to set up a test project with examples of correct and incorrect code to run the query against (the C code at the very top of this page makes a good starting point). Another approach is to test each part of the query individually to make sure everything is working.

When you have defined the basic query then you can refine the query to include further coding patterns or to exclude false positives:

Improving the query using the 'SSA' library
-------------------------------------------

The ``SSA`` library represents variables in static single assignment (SSA) form. In this form, each variable is assigned exactly once and every variable is defined before it is used. The use of SSA variables simplifies queries considerably as much of the local data flow analysis has been done for us. For more information, see `Static single assignment <https://en.wikipedia.org/wiki/Static_single_assignment_form>`__ on Wikipedia.

Including examples where the string size is stored before use
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The query above works for simple cases, but does not identify a common coding pattern where ``strlen(string)`` is stored in a variable before being passed to ``malloc``, as in the following example:

.. code-block:: cpp

       int len = strlen(input);
       buffer = malloc(len);

To identify this case we can use the standard library ``SSA.qll`` (imported as ``semmle.code.cpp.controlflow.SSA``).

This library helps us identify where values assigned to local variables may subsequently be used.

For example, consider the following code:

.. code-block:: cpp

   void myFunction(bool condition)
   {
       const char* x = "alpha"; // definition #1 of x

       printf("x = %s\n", x); // use #1 of x

       if (condition)
       {
           x = "beta"; // definition #2 of x
       } else {
           x = "gamma"; // definition #3 of x
       }

       printf("x = %s\n", x); // use #2 of x
   }

If we run the following query on the code, we get three results:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.controlflow.SSA

   from Variable var, Expr defExpr, Expr use
   where exists(SsaDefinition ssaDef |
       defExpr = ssaDef.getAnUltimateDefiningValue(var)
       and use = ssaDef.getAUse(var))
   select var, defExpr.getLocation().getStartLine() as dline, use.getLocation().getStartLine() as uline

**Results:**

+---------+-----------+-----------+
| ``var`` | ``dline`` | ``uline`` |
+=========+===========+===========+
| ``x``   | 3         | 5         |
+---------+-----------+-----------+
| ``x``   | 9         | 14        |
+---------+-----------+-----------+
| ``x``   | 11        | 14        |
+---------+-----------+-----------+

It is often useful to also display the defining expression ``defExpr``, if there is one. For example we might adjust the query above as follows:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.controlflow.SSA

   from Variable var, Expr defExpr, Expr use
   where exists(SsaDefinition ssaDef |
       defExpr = ssaDef.getAnUltimateDefiningValue(var)
       and use = ssaDef.getAUse(var))
   select var, defExpr.getLocation().getStartLine() as dline, use.getLocation().getStartLine() as uline, defExpr

Now we can see the assigned expression in our results:

+---------+-----------+-----------+-------------+
| ``var`` | ``dline`` | ``uline`` | ``defExpr`` |
+=========+===========+===========+=============+
| ``x``   | 3         | 5         | alpha       |
+---------+-----------+-----------+-------------+
| ``x``   | 9         | 14        | beta        |
+---------+-----------+-----------+-------------+
| ``x``   | 11        | 14        | gamma       |
+---------+-----------+-----------+-------------+

Extending the query to include allocations passed via a variable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using our experiments above we can expand our simple implementation of ``MallocCall.getAllocatedSize()``. With the following refinement, if the argument is an access to a variable, ``getAllocatedSize()`` returns a value assigned to that variable instead of the variable access itself:

.. code-block:: ql

   Expr getAllocatedSize() {
       if this.getArgument(0) instanceof VariableAccess then
           exists(LocalScopeVariable v, SsaDefinition ssaDef |
                   result = ssaDef.getAnUltimateDefiningValue(v)
                   and this.getArgument(0) = ssaDef.getAUse(v))
       else
           result = this.getArgument(0)
   }

The completed query will now identify cases where the result of ``strlen`` is stored in a local variable before it is used in a call to ``malloc``. Here is the query in full:

.. code-block:: ql

   import cpp

   class MallocCall extends FunctionCall
   {
       MallocCall() { this.getTarget().hasGlobalName("malloc") }

       Expr getAllocatedSize() {
           if this.getArgument(0) instanceof VariableAccess then
               exists(LocalScopeVariable v, SsaDefinition ssaDef |
                   result = ssaDef.getAnUltimateDefiningValue(v)
                   and this.getArgument(0) = ssaDef.getAUse(v))
           else
               result = this.getArgument(0)
       }
   }

   from MallocCall malloc
   where malloc.getAllocatedSize() instanceof StrlenCall
   select malloc, "This allocation does not include space to null-terminate the string."

Further reading
---------------

.. include:: ../reusables/cpp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
