Using the guards library in C and C++
=====================================

Overview
--------
The guards library (defined in ``semmle.code.cpp.controlflow.Guards``) provides a class ``GuardCondition`` representing Boolean values that are used to make control flow decisions. 
A ``GuardCondition`` is considered to guard a basic block if the block can only be reached if the ``GuardCondition`` is evaluated a certain way. For instance, in the following code, ``x < 10`` is a ``GuardCondition``, and it guards all the code before the return statement.

.. code:: cpp

    if(x < 10) {
      f(x);
    } else if (x < 20) {
      g(x);
    } else {
      h(x);
    }
    return 0;


The ``controls`` predicate
------------------------------------------------
The ``controls`` predicate helps determine which blocks are only run when the ``GuardCondition`` evaluates a certain way. ``guard.controls(block, testIsTrue)`` holds if ``block`` is only entered if the value of this condition is ``testIsTrue``.

In the following code sample, the call to ``isValid`` controls the calls to ``performAction`` and ``logFailure`` but not the return statement.

.. code:: cpp

    if(isValid(accessToken)) {
      performAction();
      succeeded = 1;
    } else {
      logFailure();
      succeeded = 0;
    }
    return succeeded;

The ``ensuresEq`` and ``ensuresLt`` predicates
----------------------------------------------
The ``ensuresEq`` and ``ensuresLt`` predicates are the main way of determining what, if any, guarantees the ``GuardCondition`` provides for a given basic block.

When ``ensuresEq(left, right, k, block, true)`` holds, then ``block`` is only executed if ``left`` was equal to ``right + k`` at their last evaluation. When ``ensuresEq(left, right, k, block, false)`` holds, then ``block`` is only executed if ``left`` was not equal to ``right + k`` at their last evaluation.

When ``ensuresLt(left, right, k, block, true)`` holds, then ``block`` is only executed if ``left`` was strictly less than ``right + k`` at their last evaluation. When ``ensuresLt(left, right, k, block, false)`` holds, then ``block`` is only executed if ``left`` was greater than or equal to ``right + k`` at their last evaluation.

.. TODO: examples for these predicates (none for others?)


The ``comparesEq`` and ``comparesLt`` predicates
------------------------------------------------
The ``comparesEq`` and ``comparesLt`` predicates help determine if the ``GuardCondition`` evaluates to true.

``comparesEq(left, right, k, true, testIsTrue)`` holds if ``left`` equals ``right + k`` when the expression evaluates to ``testIsTrue``.

``comparesLt(left, right, k, isLessThan, testIsTrue)`` holds if ``left < right + k`` evaluates to ``isLessThan`` when the expression evaluates to ``testIsTrue``.

