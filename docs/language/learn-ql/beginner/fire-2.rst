Catch the fire starter: Bald bandits
====================================

You ask the northerners if they have any more information about the fire starters. Luckily, you have a witness! The farmer living next to the field saw two people run away just after the fire started. He only saw the tops of their heads, and noticed that they were both bald.

This is a very helpful clue. Remember that you wrote a QL query to select all bald people:

.. code-block:: ql

   from Person p
   where not exists (string c | p.getHairColor() = c)
   select p

To avoid having to type ``not exists (string c | p.getHairColor() = c)`` every time you want to select a bald person, you can instead define another new predicate ``bald``.

.. code-block:: ql

   predicate bald(Person p) {
       not exists (string c | p.getHairColor() = c)
   }

The property ``bald(p)`` holds whenever ``p`` is bald, so you can replace the previous query with:

.. code-block:: ql

   from Person p
   where bald(p)
   select p

The predicate ``bald`` is defined to take a ``Person``, so it can also take a ``Southerner``, as ``Southerner`` is a subtype of ``Person``. It can't take an ``int`` for example - that would cause an error.

You can now write a query to select the bald southerners who are allowed into the north.

➤ `See the answer in the query console <https://lgtm.com/query/1505746995987/>`__

You have found the two fire starters! They are arrested and the villagers are once again impressed with your work.

What next?
----------

-  Find out who will be the new ruler of the village in the :doc:`next tutorial <heir>`.
-  Learn more about predicates and classes in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__.
-  Explore the libraries that help you get data about code in :doc:`Learning CodeQL <../../index>`.
