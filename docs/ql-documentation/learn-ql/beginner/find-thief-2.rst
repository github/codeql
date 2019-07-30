Find the thief: Start the search
================================

The villagers answered "yes" to the question "Is the thief taller than 150cm?". To use this information, you can write the following query to list all villagers taller than 150cm. These are all possible suspects.

.. code-block:: ql

   from Person t
   where t.getHeight() > 150
   select t

The first line, ``from Person t``, declares that ``t`` must be a ``Person``. We say that the `type <https://help.semmle.com/QL/ql-handbook/types.html>`__ of ``t`` is ``Person``.

Before you use the rest of your answers in your QL search, here are some more tools and examples to help you write your own QL queries:

Logical connectives
-------------------

Using `logical connectives <https://help.semmle.com/QL/ql-handbook/formulas.html#logical-connectives>`__, you can write more complex queries that combine different pieces of information.

For example, if you know that the thief is older than 30 *and* has brown hair, you can use the following ``where`` clause to link two predicates:

.. code-block:: ql

   where t.getAge() > 30 and t.getHairColor() = "brown"

.. pull-quote::

   Note

   The predicate ``getHairColor()`` returns a ``string``, so we need to include quotation marks around the result ``"brown"``.

If the thief does *not* live north of the castle, you can use:

.. code-block:: ql

   where not t.getLocation() = "north"

If the thief has brown hair *or* black hair, you can use:

.. code-block:: ql

   where t.getHairColor() = "brown" or t.getHairColor() = "black"

You can also combine these connectives into longer statements:

.. code-block:: ql

   where t.getAge() > 30
     and (t.getHairColor() = "brown" or t.getHairColor() = "black")
     and not t.getLocation() = "north"

.. pull-quote::

   Note

   We've placed parentheses around the ``or`` clause to make sure that the query is evaluated as intended. Without parentheses, the connective ``and`` takes precedence over ``or``.

Predicates don't always return exactly one value. For example, if a person ``p`` has black hair which is turning gray, ``p.getHairColor()`` will return two values: black and gray.

What if the thief is bald? In that case, the thief has no hair, so the ``getHairColor()`` predicate simply doesn't return any results!

If you know that the thief definitely isn't bald, then there must be a color that matches the thief's hair color. One way to express this in QL is to introduce a new variable ``c`` of type ``string`` and select those ``t`` where ``t.getHairColor()`` matches a value of ``c``.

.. code-block:: ql

   from Person t, string c
   where t.getHairColor() = c
   select t

Notice that we have only temporarily introduced the variable ``c`` and we didn't need it at all in the ``select`` clause. In this case, it is better to use ``exists``:

.. code-block:: ql

   from Person t
   where exists(string c | t.getHairColor() = c)
   select t

``exists`` introduces a temporary variable ``c`` of type ``string`` and holds only if there is at least one ``string c`` that satisfies ``t.getHairColor() = c``.

.. pull-quote::

   Note

   If you are familiar with logic, you may notice that ``exists`` in QL corresponds to the existential `quantifier <https://help.semmle.com/QL/ql-handbook/formulas.html#quantified-formulas>`__ in logic. QL also has a universal quantifier ``forall(vars | formula 1 | formula 2)`` which is logically equivalent to ``not(exists(vars | formula 1 | not formula 2))``.

The real investigation
----------------------

You are now ready to track down the thief! Using the examples above, write a query to find the people who satisfy the answers to the first eight questions:

+---+--------------------------------------------------------+--------+
|   | Question                                               | Answer |
+===+========================================================+========+
| 1 | Is the thief taller than 150 cm?                       | yes    |
+---+--------------------------------------------------------+--------+
| 2 | Does the thief have blond hair?                        | no     |
+---+--------------------------------------------------------+--------+
| 3 | Is the thief bald?                                     | no     |
+---+--------------------------------------------------------+--------+
| 4 | Is the thief younger than 30?                          | no     |
+---+--------------------------------------------------------+--------+
| 5 | Does the thief live east of the castle?                | yes    |
+---+--------------------------------------------------------+--------+
| 6 | Does the thief have black or brown hair?               | yes    |
+---+--------------------------------------------------------+--------+
| 7 | Is the thief taller than 180cm and shorter than 190cm? | no     |
+---+--------------------------------------------------------+--------+
| 8 | Is the thief the oldest person in the village?         | no     |
+---+--------------------------------------------------------+--------+

Hints
^^^^^

#. Don't forget to ``import tutorial``!
#. Translate each question into QL separately. Look at the examples above if you get stuck.
#. For question 3, remember that a bald person does not have a hair color.
#. For question 8, note that if a person is *not* the oldest, then there is at least one person who is older than them.
#. Combine the conditions using logical connectives to get a query of the form:

.. code-block:: ql

   import tutorial

   from Person t
   where <condition 1> and
      not <condition 2> and
      ...
   select t

Once you have finished, you will have a list of possible suspects. One of those people must be the thief!

➤ `See the answer in the query console <https://lgtm.com/query/1505743955992/>`__

.. pull-quote::

   Note

   In the answer, we used ``/*`` and ``*/`` to label the different parts of the query. Any text surrounded by ``/*`` and ``*/`` is not evaluated as part of the QL code, but is just a *comment*.

You are getting closer to solving the mystery! Unfortunately, you still have quite a long list of suspects... To find out which of your suspects is the thief, you must gather more information and refine your query in the :doc:`next step <find-thief-3>`.
