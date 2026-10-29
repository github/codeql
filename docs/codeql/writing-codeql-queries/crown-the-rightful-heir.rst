.. _crown-the-rightful-heir:

Crown the rightful heir
=======================

This is a QL detective puzzle that shows you how to use recursion in QL to write more complex queries.

King Basil's heir
-----------------

Phew! No more crimes in the village—you can finally leave the village and go home.

But then... During your last night in the village, the old king—the great King Basil—dies in his sleep and there is chaos everywhere!

The king never married and he had no children, so nobody knows who should inherit the king's castle and fortune. Immediately, lots of villagers claim that they are somehow descended from the king's family and that they are the true heir. People argue and fight and the situation seems hopeless.

Eventually you decide to stay in the village to resolve the argument and find the true heir to the throne.

You want to find out if anyone in the village is actually related to the king. This seems like a difficult task at first, but you start work confidently. You know the villagers quite well by now, and you have a list of all the parents in the village and their children.

To find out more about the king and his family, you get access to the castle and find some old family trees. You also include these relations in your database to see if anyone in the king's family is still alive.

The following predicate is useful to help you access the data:

+------------------------+---------------------------+
| Predicate              | Description               |
+========================+===========================+
| ``parentOf(Person p)`` | returns a parent of ``p`` |
+------------------------+---------------------------+

For example, you can list all children ``p`` together with their parents:

.. code-block:: ql

   from Person p
   select parentOf(p) + " is a parent of " + p

There is too much information to search through by hand, so you write a QL query to help you find the king's heir.

We know that the king has no children himself, but perhaps he has siblings. Write a query to find out:

.. code-block:: ql

   from Person p
   where parentOf(p) = parentOf("King Basil") and
     not p = "King Basil"
   select p

He does indeed have siblings! But you need to check if any of them are alive... Here is one more predicate you might need:

+------------------+---------------------------------+
| Predicate        | Description                     |
+==================+=================================+
| ``isDeceased()`` | holds if the person is deceased |
+------------------+---------------------------------+

Use this predicate to see if the any of the king's siblings are alive.

.. code-block:: ql

   from Person p
   where parentOf(p) = parentOf("King Basil") and
     not p = "King Basil"
     and not p.isDeceased()
   select p

Unfortunately, none of King Basil's siblings are alive. Time to investigate further. It might be helpful to define a predicate ``childOf()`` which returns a child of the person. To do this, the ``parentOf()`` predicate can be used inside the definition of ``childOf()``. Remember that someone is a child of ``p`` if and only if ``p`` is their parent:

.. code-block:: ql

   Person childOf(Person p) {
     p = parentOf(result)
   }

.. pull-quote::

   Note

   As illustrated by the example above, you don't have to directly write ``result = <expression involving p>`` in the predicate definition. Instead you can also express the relation between ``p`` and ``result`` "backwards" by writing ``p`` in terms of ``result``.

Try to write a query to find out if any of the king's siblings have children:

.. code-block:: ql

   from Person p
   where parentOf(p) = parentOf("King Basil") and
     not p = "King Basil"
   select childOf(p)

The query returns no results, so they have no children. But perhaps King Basil has a cousin who is alive or has children, or a second cousin, or...

This is getting complicated. Ideally, you want to define a predicate ``relativeOf(Person p)`` that lists all the relatives of ``p``.

How could you do that?

It helps to think of a precise definition of *relative*. A possible definition is that two people are related if they have a common ancestor.

You can introduce a predicate ``ancestorOf(Person p)`` that lists all ancestors of ``p``. An ancestor of ``p`` is just a parent of ``p``, or a parent of a parent of ``p``, or a parent of a parent of a parent of ``p``, and so on. Unfortunately, this leads to an endless list of parents. You can't write an infinite QL query, so there must be an easier approach.

Aha, you have an idea! You can say that an ancestor is either a parent, or a parent of someone you already know to be an ancestor.

You can translate this into QL as follows:

.. code-block:: ql

   Person ancestorOf(Person p) {
     result = parentOf(p) or
     result = parentOf(ancestorOf(p))
   }

As you can see, you have used the predicate ``ancestorOf()`` inside its own definition. This is an example of :ref:`recursion <recursion>`.

This kind of recursion, where the same operation (in this case ``parentOf()``) is applied multiple times, is very common in QL, and is known as the *transitive closure* of the operation. There are two special symbols ``+`` and ``*`` that are extremely useful when working with transitive closures:

-  ``parentOf+(p)`` applies the ``parentOf()`` predicate to ``p`` one or more times. This is equivalent to ``ancestorOf(p)``.
-  ``parentOf*(p)`` applies the ``parentOf()`` predicate to ``p`` zero or more times, so it returns an ancestor of ``p`` or ``p`` itself.

Try using this new notation to define a predicate ``relativeOf()`` and use it to list all living relatives of the king.

Hint:

Here is one way to define ``relativeOf()``:

.. code-block:: ql

   Person relativeOf(Person p) {
     parentOf*(result) = parentOf*(p)
   }

Don't forget to use the predicate ``isDeceased()`` to find relatives that are still alive.

➤ `Check your answer <#exercise-1>`__

Select the true heir
--------------------

At the next village meeting, you announce that there are two living relatives.

To decide who should inherit the king's fortune, the villagers carefully read through the village constitution:

*"The heir to the throne is the closest living relative of the king. Any person with a criminal record will not be considered. If there are multiple candidates, the oldest person is the heir."*

As your final challenge, define a predicate ``hasCriminalRecord`` so that ``hasCriminalRecord(p)`` holds if ``p`` is any of the criminals you unmasked earlier (in the ":doc:`Find the thief <find-the-thief>`" and ":doc:`Catch the fire starter <catch-the-fire-starter>`" tutorials).

➤ `Check your answer <#exercise-2>`__

Experimental explorations
-------------------------

Congratulations! You have found the heir to the throne and restored peace to the village. However, you don't have to leave the villagers just yet. There are still a couple more questions about the village constitution that you could answer for the villagers, by writing QL queries:

-  Which villager is next in line to the throne? Could you write a predicate to determine how closely related the remaining villagers are to the new monarch?
-  How would you select the oldest candidate using a QL query, if multiple villagers have the same relationship to the monarch?

You could also try writing more of your own QL queries to find interesting facts about the villagers. You are free to investigate whatever you like, but here are some suggestions:

-  What is the most common hair color in the village? And in each region?
-  Which villager has the most children? Who has the most descendants?
-  How many people live in each region of the village?
-  Do all villagers live in the same region of the village as their parents?
-  Find out whether there are any time travelers in the village! (Hint: Look for "impossible" family relations.)

Further reading
---------------

.. include:: ../reusables/codeql-ref-tools-further-reading.rst

--------------

Answers
-------

In these answers, we use ``/*`` and ``*/`` to label the different parts of the query. Any text surrounded by ``/*`` and ``*/`` is not evaluated as part of the QL code, but is treated as a *comment*.

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   import tutorial

   Person relativeOf(Person p) { parentOf*(result) = parentOf*(p) }

   from Person p
   where
     not p.isDeceased() and
     p = relativeOf("King Basil")
   select p

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   import tutorial

   Person relativeOf(Person p) { parentOf*(result) = parentOf*(p) }

   predicate hasCriminalRecord(Person p) {
     p = "Hester" or
     p = "Hugh" or
     p = "Charlie"
   }

   from Person p
   where
     not p.isDeceased() and
     p = relativeOf("King Basil") and
     not hasCriminalRecord(p)
   select p
