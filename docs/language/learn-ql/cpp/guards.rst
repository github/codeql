Using the guards library in C and C++
=====================================

Overview
--------
The guards library (defined in ``semmle.code.cpp.controlflow.Guards``) provides a class ``GuardCondition`` representing boolean values which are used to make control flow decisions.

The ``ensuresEq`` and ``ensuresLt`` predicates
----------------------------------------------
The ``ensuresLt`` and ``ensuresEq`` predicates are the main way of determining what, if any, guarantees the ``GuardCondition`` provides for a given basic block.

``ensuresEq(left, right, k, block, areEqual)`` holds if ``left == right + k`` must be ``areEqual`` for ``block`` to be executed. If ``areEqual = false`` then this implies ``left != right + k`` must be true for ``block`` to be executed.

``ensuresLt(left, right, k, block, isLessThan)`` holds if ``left < right + k`` must be ``isLessThan`` for ``block`` to be executed. If ``isLessThan = false`` then this implies ``left >= right + k`` must be true for ``block`` to be executed.

.. TODO: examples for these predicates (none for others?)


The ``comparesEq`` and ``comparesLt`` predicates
------------------------------------------------
The ``comparesEq`` and ``comparesLt`` predicates help determine if the ``GuardCondition`` evaluates to true.

``comparesEq(left, right, k, areEqual, testIsTrue)`` holds if ``left == right + k`` evaluates to ``areEqual`` if the expression evaluates to ``testIsTrue``.

``comparesLt(left, right, k, isLessThan, testIsTrue)`` holds if ``left < right + k`` evaluates to ``isLessThan`` if the expression evaluates to ``testIsTrue``.

The ``controls`` predicate
------------------------------------------------
The ``controls`` predicate helps determine which blocks are only run when the ``IRGuardCondition`` evaluates a certain way. ``controls(block, testIsTrue)`` holds if ``block`` is only entered if the value of this condition is ``testIsTrue``.