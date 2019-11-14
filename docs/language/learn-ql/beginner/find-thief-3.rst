Find the thief: More advanced queries
=====================================

What if you want to find the oldest, youngest, tallest, or shortest person in the village? As mentioned in the previous topic, you can do this using ``exists``. However, there is also a more efficient way to do this in QL using functions like ``max`` and ``min``. These are examples of `aggregates <https://help.semmle.com/QL/ql-handbook/expressions.html#aggregations>`__.

In general, an aggregate is a function that performs an operation on multiple pieces of data and returns a single value as its output. Common aggregates are ``count``, ``max``, ``min``, ``avg`` (average) and ``sum``. The general way to use an aggregate is:

.. code-block:: ql

   <aggregate>(<variable declarations> | <logical formula> | <expression>)

For example, you can use the ``max`` aggregate to find the age of the oldest person in the village:

.. code-block:: ql

   max(int i | exists(Person p | p.getAge() = i) | i)

This aggregate considers all integers ``i``, limits ``i`` to values that match the ages of people in the village, and then returns the largest matching integer.

But how can you use this in an actual query?

If the thief is the oldest person in the village, then you know that the thief's age is equal to the maximum age of the villagers:

.. code-block:: ql

   from Person t
   where t.getAge() = max(int i | exists(Person p | p.getAge() = i) | i)
   select t

This general aggregate syntax is quite long and inconvenient. In most cases, you can omit certain parts of the aggregate. A particularly helpful QL feature is *ordered aggregation*. This allows you to order the expression using ``order by``.

For example, selecting the oldest villager becomes much simpler if you use an ordered aggregate.

.. code-block:: ql

   select max(Person p | | p order by p.getAge())

The ordered aggregate considers every person ``p`` and selects the person with the maximum age. In this case, there are no restrictions on what people to consider, so the ``<logical formula>`` clause is empty. Note that if there are several people with the same maximum age, the query lists all of them.

Here are some more examples of aggregates:

+-------------------------------------------------------------------------+---------------------------------------------------+
| Example                                                                 | Result                                            |
+=========================================================================+===================================================+
| ``min(Person p | p.getLocation() = "east" | p order by p.getHeight())`` | shortest person in the east of the village        |
+-------------------------------------------------------------------------+---------------------------------------------------+
| ``count(Person p | p.getLocation() = "south" | p)``                     | number of people in the south of the village      |
+-------------------------------------------------------------------------+---------------------------------------------------+
| ``avg(Person p | | p.getHeight())``                                     | average height of the villagers                   |
+-------------------------------------------------------------------------+---------------------------------------------------+
| ``sum(Person p | p.getHairColor() = "brown" | p.getAge())``             | combined age of all the villagers with brown hair |
+-------------------------------------------------------------------------+---------------------------------------------------+

Capture the culprit
-------------------

You can now translate the remaining questions into QL:

+-----+--------------------------------------------------------------------+--------+
|     | Question                                                           | Answer |
+=====+====================================================================+========+
| ... | ...                                                                | ...    |
+-----+--------------------------------------------------------------------+--------+
| 9   | Is the thief the tallest person in the village?                    | no     |
+-----+--------------------------------------------------------------------+--------+
| 10  | Is the thief shorter than the average villager?                    | yes    |
+-----+--------------------------------------------------------------------+--------+
| 11  | Is the thief the oldest person in the eastern part of the village? | yes    |
+-----+--------------------------------------------------------------------+--------+

Have you found the thief?

➤ `See the answer in the query console <https://lgtm.com/query/1505744186085/>`__

What next?
----------

-  Help the villagers track down another criminal in the :doc:`next tutorial <fire-1>`.
-  Find out more about the concepts you discovered in this tutorial in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__.
-  Explore the libraries that help you get data about code in :doc:`Learning CodeQL <../../index>`.
