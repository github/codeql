Catch the fire starter: Classes and predicates
==============================================

Just as you've successfully found the thief and returned the golden crown to the castle, another terrible crime is committed. Early in the morning, a few people start a fire in a field in the north of the village and destroy all the crops!

You now have the reputation of being an expert QL detective, so you are once again asked to find the culprits.

This time, you have some additional information. There is a strong rivalry between the north and south of the village and you know that the criminals live in the south.

Read the examples below to learn how to define predicates and classes in QL. These make the logic of your queries easier to understand and will help simplify your detective work.

Select the southerners
----------------------

This time you only need to consider a specific group of villagers, namely those living in the south of the village. Instead of writing ``getLocation() = "south"`` in all your queries, you could define a new `predicate <https://help.semmle.com/QL/ql-handbook/predicates.html>`__ ``southern``:

.. code-block:: ql

   predicate southern(Person p) {
       p.getLocation() = "south"
   }

The predicate ``southern(p)`` takes a single parameter ``p`` and checks if ``p`` satisfies the property ``p.getLocation() = "south"``.

.. pull-quote::

   Note

   -  The name of a predicate always starts with a lowercase letter.
   -  You can also define predicates with a result. In that case, the keyword ``predicate`` is replaced with the type of the result. This is like introducing a new argument, the special variable ``result``. For example, ``int getAge() {result = ...}`` returns an ``int``.

You can now list all southerners using:

.. code-block:: ql

   /* define predicate `southern` as above */

   from Person p
   where southern(p)
   select p

This is already a nice way to simplify the logic, but we could be more efficient. Currently, the query looks at every ``Person p``, and then restricts to those who satisfy ``southern(p)``. Instead, we could define a new `class <https://help.semmle.com/QL/ql-handbook/types.html#classes>`__ ``Southerner`` containing precisely the people we want to consider.

.. code-block:: ql

   class Southerner extends Person {
       Southerner() { southern(this) }
   }

A class in QL represents a logical property: when a value satisfies that property, it is a member of the class. This means that a value can be in many classes - being in a particular class doesn't stop it from being in other classes too.

The expression ``southern(this)`` defines the logical property represented by the class, called its *characteristic predicate*. It uses a special variable ``this`` and indicates that a ``Person`` "``this``" is a ``Southerner`` if the property ``southern(this)`` holds.

.. pull-quote::

   Note

   If you are familiar with object-oriented programming languages, you might be tempted to think of the characteristic predicate as a *constructor*. However, this is **not** the case - it is a logical property which does not create any objects.

You always need to define a class in QL in terms of an existing (larger) class. In our example, a ``Southerner`` is a special kind of ``Person``, so we say that ``Southerner`` *extends* ("is a subset of") ``Person``.

Using this class you can now list all people living in the south simply as:

.. code-block:: ql

   from Southerner s
   select s

You may have noticed that some predicates are appended, for example ``p.getAge()``, while others are not, for example ``southern(p)``. This is because ``getAge()`` is a member predicate, that is, a predicate that only applies to members of a class. You define such a member predicate inside a class. In this case, ``getAge()`` is defined inside the class ``Person``. In contrast, ``southern`` is defined separately and is not inside any classes. Member predicates are especially useful because you can chain them together easily. For example, ``p.getAge().sqrt()`` first gets the age of ``p`` and then calculates the square root of that number.

Travel restrictions
-------------------

Another factor you want to consider is the travel restrictions imposed following the theft of the crown. Originally there were no restrictions on where villagers could travel within the village. Consequently the predicate ``isAllowedIn(string region)`` held for any person and any region. The following query lists all villagers, since they could all travel to the north:

.. code-block:: ql

   from Person p
   where p.isAllowedIn("north")
   select p

However, after the recent theft, the villagers have become more anxious of criminals lurking around the village and they no longer allow children under the age of 10 to travel out of their home region.

This means that ``isAllowedIn(string region)`` no longer holds for all people and all regions, so you should temporarily *override* the original predicate if ``p`` is a child.

Start by defining a class ``Child`` containing all villagers under 10 years old. Then you can redefine ``isAllowedIn(string region)`` as a member predicate of ``Child`` to allow children only to move within their own region. This is expressed by ``region = this.getLocation()``.

.. code-block:: ql

   class Child extends Person {

       /* the characteristic predicate */
       Child() { this.getAge() < 10 }

       /* a member predicate */
       override predicate isAllowedIn(string region) {
           region = this.getLocation()
       }
   }

Now try applying ``isAllowedIn(string region)`` to a person ``p``. If ``p`` is not a child, the original definition is used, but if ``p`` is a child, the new predicate definition overrides the original.

You know that the fire starters live in the south *and* that they must have been able to travel to the north. Write a query to find the possible suspects. You could also extend the ``select`` clause to list the age of the suspects. That way you can clearly see that all the children have been excluded from the list.

➤ `See the answer in the query console <https://lgtm.com/query/2164870087/>`__

Continue to the :doc:`next page <fire-2>` to gather more clues and find out which of your suspects started the fire...
