.. _find-the-thief:

Find the thief
==============

Take on the role of a detective to find the thief in this fictional village. You will learn how to use logical connectives, quantifiers, and aggregates in QL along the way.

Introduction
------------

There is a small village hidden away in the mountains. The village is divided into four parts—north, south, east, and west—and in the center stands a dark and mysterious castle... Inside the castle, locked away in the highest tower, lies the king's valuable golden crown. One night, a terrible crime is committed. A thief breaks into the tower and steals the crown!

You know that the thief must live in the village, since nobody else knew about the crown. After some expert detective work, you obtain a list of all the people in the village and some of their personal details.

+------+-----+------------+--------+----------+
| Name | Age | Hair color | Height | Location |
+======+=====+============+========+==========+
| ...  | ... | ...        | ...    | ...      |
+------+-----+------------+--------+----------+

Sadly, you still have no idea who could have stolen the crown so you walk around the village to find clues. The villagers act very suspiciously and you are convinced they have information about the thief. They refuse to share their knowledge with you directly, but they reluctantly agree to answer questions. They are still not very talkative and **only answer questions with 'yes' or 'no'**.

You start asking some creative questions and making notes of the answers so you can compare them with your information later:

+------+--------------------------------------------------------------------+--------+
|      | Question                                                           | Answer |
+======+====================================================================+========+
| (1)  | Is the thief taller than 150 cm?                                   | yes    |
+------+--------------------------------------------------------------------+--------+
| (2)  | Does the thief have blond hair?                                    | no     |
+------+--------------------------------------------------------------------+--------+
| (3)  | Is the thief bald?                                                 | no     |
+------+--------------------------------------------------------------------+--------+
| (4)  | Is the thief younger than 30?                                      | no     |
+------+--------------------------------------------------------------------+--------+
| (5)  | Does the thief live east of the castle?                            | yes    |
+------+--------------------------------------------------------------------+--------+
| (6)  | Does the thief have black or brown hair?                           | yes    |
+------+--------------------------------------------------------------------+--------+
| (7)  | Is the thief taller than 180cm and shorter than 190cm?             | no     |
+------+--------------------------------------------------------------------+--------+
| (8)  | Is the thief the oldest person in the village?                     | no     |
+------+--------------------------------------------------------------------+--------+
| (9)  | Is the thief the tallest person in the village?                    | no     |
+------+--------------------------------------------------------------------+--------+
| (10) | Is the thief shorter than the average villager?                    | yes    |
+------+--------------------------------------------------------------------+--------+
| (11) | Is the thief the oldest person in the eastern part of the village? | yes    |
+------+--------------------------------------------------------------------+--------+

There is too much information to search through by hand, so you decide to use your newly acquired QL skills to help you with your investigation...

.. include:: ../reusables/codespaces-template-note.rst

QL libraries
------------

We've defined a number of QL :ref:`predicates <predicates>` to help you extract data from your table. A QL predicate is a mini-query that expresses a relation between various pieces of data and describes some of their properties. In this case, the predicates give you information about a person, for example their height or age.

+--------------------+----------------------------------------------------------------------------------------+
| Predicate          | Description                                                                            |
+====================+========================================================================================+
| ``getAge()``       | returns the age of the person (in years) as an ``int``                                 |
+--------------------+----------------------------------------------------------------------------------------+
| ``getHairColor()`` | returns the hair color of the person as a ``string``                                   |
+--------------------+----------------------------------------------------------------------------------------+
| ``getHeight()``    | returns the height of the person (in cm) as a ``float``                                |
+--------------------+----------------------------------------------------------------------------------------+
| ``getLocation()``  | returns the location of the person's home (north, south, east or west) as a ``string`` |
+--------------------+----------------------------------------------------------------------------------------+

We've stored these predicates in the QL library ``tutorial.qll``. To access this library, type ``import tutorial`` in the query console.

Libraries are convenient for storing commonly used predicates. This saves you from defining a predicate every time you need it. Instead you can just ``import`` the library and use the predicate directly. Once you have imported the library, you can apply any of these predicates to an expression by appending it.

For example, ``t.getHeight()`` applies ``getHeight()`` to ``t`` and returns the height of ``t``.

Start the search
-----------------

The villagers answered "yes" to the question "Is the thief taller than 150cm?" To use this information, you can write the following query to list all villagers taller than 150cm. These are all possible suspects.

.. code-block:: ql

   from Person t
   where t.getHeight() > 150
   select t

The first line, ``from Person t``, declares that ``t`` must be a ``Person``. We say that the :ref:`type <types>` of ``t`` is ``Person``.

Before you use the rest of your answers in your QL search, here are some more tools and examples to help you write your own QL queries:

Logical connectives
-------------------

Using :ref:`logical connectives <logical-connectives>`, you can write more complex queries that combine different pieces of information.

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

   If you are familiar with logic, you may notice that ``exists`` in QL corresponds to the existential :ref:`quantifier <quantified-formulas>` in logic. QL also has a universal quantifier ``forall(vars | formula 1 | formula 2)`` which is logically equivalent to ``not exists(vars | formula 1 | not formula 2)``.

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

➤ `Check your answer <#exercise-1>`__

You are getting closer to solving the mystery! Unfortunately, you still have quite a long list of suspects... To find out which of your suspects is the thief, you must gather more information and refine your query in the next step.

More advanced queries
---------------------

What if you want to find the oldest, youngest, tallest, or shortest person in the village? As mentioned in the previous topic, you can do this using ``exists``. However, there is also a more efficient way to do this in QL using functions like ``max`` and ``min``. These are examples of :ref:`aggregates <aggregations>`.

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

➤ `Check your answer <#exercise-2>`__

Further reading
---------------

.. include:: ../reusables/codeql-ref-tools-further-reading.rst


--------------

Answers
-------

In these answers, we use ``/*`` and ``*/`` to label the different parts of the query. Any text surrounded by ``/*`` and ``*/`` is not evaluated as part of the QL code, but is treated as a *comment*.

Exercise 1
^^^^^^^^^^

.. code-block:: ql

   import tutorial

   from Person t
   where
     /* 1 */ t.getHeight() > 150 and
     /* 2 */ not t.getHairColor() = "blond" and
     /* 3 */ exists (string c | t.getHairColor() = c) and
     /* 4 */ not t.getAge() < 30 and
     /* 5 */ t.getLocation() = "east" and
     /* 6 */ (t.getHairColor() = "black" or t.getHairColor() = "brown") and
     /* 7 */ not (t.getHeight() > 180 and t.getHeight() < 190) and
     /* 8 */ exists(Person p | p.getAge() > t.getAge())
   select t

Exercise 2
^^^^^^^^^^

.. code-block:: ql

   import tutorial

   from Person t
   where
     /* 1 */ t.getHeight() > 150 and
     /* 2 */ not t.getHairColor() = "blond" and
     /* 3 */ exists (string c | t.getHairColor() = c) and
     /* 4 */ not t.getAge() < 30 and
     /* 5 */ t.getLocation() = "east" and
     /* 6 */ (t.getHairColor() = "black" or t.getHairColor() = "brown") and
     /* 7 */ not (t.getHeight() > 180 and t.getHeight() < 190) and
     /* 8 */ exists(Person p | p.getAge() > t.getAge()) and
     /* 9 */ not t = max(Person p | | p order by p.getHeight()) and
     /* 10 */ t.getHeight() < avg(float i | exists(Person p | p.getHeight() = i) | i) and
     /* 11 */ t = max(Person p | p.getLocation() = "east" | p order by p.getAge())
   select "The thief is " + t + "!"
   