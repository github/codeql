Find the thief: Introduction
============================

There is a small village hidden away in the mountains. The village is divided into four parts - north, south, east, and west - and in the center stands a dark and mysterious castle... Inside the castle, locked away in the highest tower, lies the king's valuable golden crown. One night, a terrible crime is committed. A thief breaks into the tower and steals the crown!

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
| (8)  | Is the thief the tallest person in the village?                    | no     |
+------+--------------------------------------------------------------------+--------+
| (9)  | Is the thief shorter than the average villager?                    | yes    |
+------+--------------------------------------------------------------------+--------+
| (10) | Is the thief the oldest person in the eastern part of the village? | yes    |
+------+--------------------------------------------------------------------+--------+

There is too much information to search through by hand, so you decide to use your newly acquired QL skills to help you with your investigation...

#. Open the `query console <https://lgtm.com/query>`__ to get started.
#. Select a language and a demo project. For this tutorial, any language and project will do.
#. Delete the default code ``import <language> select "hello world"``.

QL libraries
------------

We've defined a number of QL `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__ to help you extract data from your table. A QL predicate is a mini-query that expresses a relation between various pieces of data and describes some of their properties. In this case, the predicates give you information about a person, for example their height or age.

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

Continue to the next page to :doc:`start the investigation <find-thief-2>`.
