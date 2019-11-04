Understanding the difference between != and not(=)
==================================================

The two expressions:

#. ``a() != b()``
#. ``not(a() = b())``

look equivalent - so much so that inexperienced (and even experienced) programmers have been known to rewrite one as the other. However, they are not equivalent due to the quantifiers involved.

Thinking of ``a()`` and ``b()`` as sets of values, the first expression says that there is a pair of values (one from each side of the inequality) which are different.

**Using !=**

::

   exists x, y | x in a() and y in b() | x != y

The second expression, however, says that it is *not* the case that there is a pair of values which are the *same* - that is, *all* pairs of values are different:

**Using not(=)**

::

   not exists x, y | x in a() and y in b() | x = y

This is equivalent to: ``forall x, y | x in a() and y in b() | x != y``. The meaning is very different from the first expression.

Examples
--------

``a() = {1, 2}`` and ``b() = {1}``:

#. ``a() != b()`` is true, because ``2 != 1``
#. ``a() = b()`` is true, because ``1 = 1``
#. Therefore\ ``: not(a() = b())`` is false - a different answer from the comparison ``a() != b()``

Similarly with ``a() = {}`` and ``b() = {1}``:

#. ``a() != b()`` is false, because there is no value in ``a()`` that is not equal to ``1``
#. ``a() = b()`` is also false, because there is no value in ``a()`` that is equal to ``1`` either
#. Therefore: ``not(a() = b())`` is true - again a different answer from the comparison ``a() != b()``

In summary, the QL expressions ``a() != b()`` and ``not(a() = b())`` may look similar, but their meaning is quite different.
