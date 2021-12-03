.. _using-the-guards-library-in-cpp:

Using the guards library in C and C++
=====================================

You can use the CodeQL guards library to identify conditional expressions that control the execution of other parts of a program in C and C++ codebases. 

About the guards library
------------------------

The guards library (defined in ``semmle.code.cpp.controlflow.Guards``) provides a class `GuardCondition <https://codeql.github.com/codeql-standard-libraries/cpp/semmle/code/cpp/controlflow/Guards.qll/type.Guards$GuardCondition.html>`__ representing Boolean values that are used to make control flow decisions.
A ``GuardCondition`` is considered to guard a basic block if the block can only be reached if the ``GuardCondition`` is evaluated a certain way. For instance, in the following code, ``x < 10`` is a ``GuardCondition``, and it guards all the code before the return statement.

.. code-block:: cpp

    if(x < 10) {
      f(x);
    } else if (x < 20) {
      g(x);
    } else {
      h(x);
    }
    return 0;


The ``controls`` predicate
--------------------------

The ``controls`` predicate helps determine which blocks are only run when the ``GuardCondition`` evaluates a certain way. ``guard.controls(block, testIsTrue)`` holds if ``block`` is only entered if the value of this condition is ``testIsTrue``.

In the following code sample, the call to ``isValid`` controls the calls to ``performAction`` and ``logFailure`` but not the return statement.

.. code-block:: cpp

    if(isValid(accessToken)) {
      performAction();
      succeeded = 1;
    } else {
      logFailure();
      succeeded = 0;
    }
    return succeeded;

In the following code sample, the call to ``isValid`` controls the body of the
``if`` statement, and also the code after the ``if``.

.. code-block:: cpp

    if(!isValid(accessToken)) {
      logFailure();
      return 0;
    }
    performAction();
    return succeeded;

The ``ensuresEq`` and ``ensuresLt`` predicates
----------------------------------------------

The ``ensuresEq`` and ``ensuresLt`` predicates are the main way of determining what, if any, guarantees the ``GuardCondition`` provides for a given basic block.

The ``ensuresEq`` predicate
***************************


When ``ensuresEq(left, right, k, block, true)`` holds, then ``block`` is only executed if ``left`` was equal to ``right + k`` at their last evaluation. When ``ensuresEq(left, right, k, block, false)`` holds, then ``block`` is only executed if ``left`` was not equal to ``right + k`` at their last evaluation.

The ``ensuresLt`` predicate
***************************

When ``ensuresLt(left, right, k, block, true)`` holds, then ``block`` is only executed if ``left`` was strictly less than ``right + k`` at their last evaluation. When ``ensuresLt(left, right, k, block, false)`` holds, then ``block`` is only executed if ``left`` was greater than or equal to ``right + k`` at their last evaluation.

In the following code sample, the comparison on the first line ensures that ``index`` is less than ``size`` in the "then" block, and that ``index`` is greater than or equal to ``size`` in the "else" block.

.. code-block:: cpp

    if(index < size) {
      ret = array[index];
    } else {
      ret = nullptr
    }
    return ret;

The ``comparesEq`` and ``comparesLt`` predicates
------------------------------------------------

The ``comparesEq`` and ``comparesLt`` predicates help determine if the ``GuardCondition`` evaluates to true.

The ``comparesEq`` predicate
****************************

``comparesEq(left, right, k, true, testIsTrue)`` holds if ``left`` equals ``right + k`` when the expression evaluates to ``testIsTrue``.

The ``comparesLt`` predicate
****************************

``comparesLt(left, right, k, isLessThan, testIsTrue)`` holds if ``left < right + k`` evaluates to ``isLessThan`` when the expression evaluates to ``testIsTrue``.

Further reading
---------------

.. include:: ../reusables/cpp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst

