Monotonic aggregates in QL
==========================

In addition to standard QL aggregates, QL also supports *monotonic* aggregates. These are a slightly different way of computing aggregates which have some advantages, notably the ability to be used recursively, which normal aggregates do not have. You can enable them in a scope by adding the \ ``language[monotonicAggregates]`` pragma on a predicate, class, or module.

Syntax
------

A QL aggregate is written in the following way:

.. code-block:: ql

   aggregate(Type t, ... | range | expression)

Where ``range`` is a QL formula, and ``expression`` is a QL expression. For example, you might write:

.. code-block:: ql

   sum(Employee e | managedByMe(e) | e.getSalary())

to add up the salaries of the employees you manage.

An aggregate is a QL expression. This means it may be equated to a variable or passed as an argument to a method or predicate, just like other expressions.

The aggregate functions that are available are:

-  ``count`` - counts the expression values
-  ``strictcount`` - counts the expression values, but fails if the range ever fails
-  ``sum`` - sums the expression values
-  ``strictsum`` - sums the expression values, but fails if the range ever fails
-  ``avg`` - averages the expression values
-  ``max`` - takes the maximum of the expression values
-  ``min`` - takes the minimum of the expression values
-  ``rank`` - ranks the variable values by their expression value

``strictcount``, ``strictsum`` and ``rank`` are a little unusual, and are discussed in more detail `below <#aggregate-variants>`__.

Semantics
---------

For most usages, aggregates have very straightforward behavior. They can be thought of according to the following recipe:

   For every combination of values for the declared **variables**, for which the **range** holds, take one value of the **expression** and apply the **aggregation function** to the resulting values.

How does this work? Let us take the simple example given above of calculating the sum of your employees' salaries. Suppose that your employees are Alice, Ben and Charles, whose salaries are $30k, $40k, and $50k respectively. Then to calculate ``result``, we follow our recipe:

+----------------------------------------------------------------+-------------------------------------+
| For every combination of values for the declared **variables** | Alice, Ben, Charles, Denis, Edna... |
+================================================================+=====================================+
| for which the **range** holds                                  | Alice, Ben, Charles                 |
+----------------------------------------------------------------+-------------------------------------+
| take one value of the \ **expression**                         | $50k, $30k, $50k                    |
+----------------------------------------------------------------+-------------------------------------+
| and apply the **aggregation function** to the resulting values | sum($50k, $30k, $50k) = $130k       |
+----------------------------------------------------------------+-------------------------------------+

Missing expression values
~~~~~~~~~~~~~~~~~~~~~~~~~

Our recipe is simple enough when there is precisely one value of the expression for each value given by the range - but what happens if there is not? QL is a relational language, so this is quite possible. Consider the following QL code:

.. code-block:: ql

   int totalProjectTime() {
     result = sum(Employee e | managedByMe(e) | e.getAProject().getRunTime())
   }

What happens when an employee does not have any projects? In this case when we follow our recipe, there will be **no** values available for the expression, and so we will fail to produce any results at all. Let us suppose that Charles has no projects, then our recipe goes as follows:

+----------------------------------------------------------------+-------------------------------------+
| For every combination of values for the declared **variables** | Alice, Ben, Charles, Denis, Edna... |
+================================================================+=====================================+
| for which the **range** holds                                  | Alice, Ben, Charles                 |
+----------------------------------------------------------------+-------------------------------------+
| take one value of the \ **expression**                         | Project A, Project B, ``<none>``    |
+----------------------------------------------------------------+-------------------------------------+
| and apply the **aggregation function** to the resulting values |                                     |
+----------------------------------------------------------------+-------------------------------------+

This is probably an error in defining the query. The writer probably intended something more like this:

.. code-block:: ql

   int totalProjectTime() {
     result = sum(Project p | exists(Employee e | managedByMe(e) | p = e.getAProject()) | p.getRunTime())
   }

This will correctly ignore employees who have no projects, although it will still fail if some projects do not have a run time.

This kind of failure can be benign, and it is crucial to the proper behavior of recursive aggregation.

Multiple expression values
~~~~~~~~~~~~~~~~~~~~~~~~~~

Not only may QL expressions have no values, they may have multiple values. Consider the following example:

.. code-block:: ql

   int getProjectCostEstimate(Employee e) {
     result = sum(Project p | e.getAProject() = p | p.getAnEstimate())
   }

Let us suppose that ``Project.getAnEstimate`` is populated by asking a selection of people for an estimate on the project cost. In this case, the expression will return **multiple** estimates (as is common for QL methods named ``getA*``). For our example, suppose that an employee owns Project C and Project F, and the estimates for Project C are ($20k, $30k) and for Project F there is only ($40k). Then, following our recipe:

+----------------------------------------------------------------+------------------------------------------------------+
| For every combination of values for the declared **variables** | Project A, Project B, Project C...                   |
+================================================================+======================================================+
| for which the **range** holds                                  | Project C, Project F                                 |
+----------------------------------------------------------------+------------------------------------------------------+
| take one value of the \ **expression**                         | ($20k, $40K) **or** ($30k, $40k)                     |
+----------------------------------------------------------------+------------------------------------------------------+
| and apply the **aggregation function** to the resulting values | sum($20k, $40k) = $60k **or** sum($30k, $40k) = $70k |
+----------------------------------------------------------------+------------------------------------------------------+

So in this case we actually get **two** values for ``result``. Since there were two possibilities for ``getAnEstimate`` for Project C, we got a total of 2 (for Project C) x 1 (for Project F) = 2 combinations of estimates, each of which gives a different value when aggregated. If there were more estimates for Project F, or more projects, each with their own set of estimates, then we would get more output values for the aggregate - one for each possible assignment of estimates to projects.

This means that ``getProjectCostEstimate`` gives us a spread of options, capturing the range of different possible values we might get depending on which estimates are correct.

Thinking about possible assignments to the variables also provides a different perspective on the previous section. An aggregation can fail to produce a value if the expression has no values for one of the aggregated entities because then there are **no** possible assignments of expression values to aggregated entities.

The multivalued aspect of monotonic aggregates is less commonly used because monotonic aggregates with multiple expression values will often produce a large number of results, reflecting the various possible expression values. This is rarely what is intended, and can be expensive to compute (min, max, and count are exceptions to this, and have linear performance in all cases).

If you have an unintentionally multivalued expression, this can usually be resolved by moving the multivalued part to the range and binding it to a new aggregation variable.

Recursion
~~~~~~~~~

Aggregates **may** be used recursively, but the recursive call may only appear in the expression, and not in the range. For example, we might define a predicate to calculate the distance of a node in a graph from the leaves as follows:

.. code-block:: ql

   int depth(Node n) {
     if not exists(n.getAChild())
     then result = 0
     else result = 1 + max(Node child | child = n.getAChild() | depth(child))
   }

Here the recursive call is in the expression, which is legal.

The recursive semantics for aggregates are the same as the recursive semantics for the rest of QL. If you understand how aggregates work in the non-recursive case then you should not find it difficult to use them recursively. However, it is worth seeing how the evaluation of a recursive aggregation proceeds.

Consider the depth example we just saw with the following graph as input (arrows point from children to parents):

|image0|

Then the evaluation of the ``depth`` predicate proceeds as follows:

+-----------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Stage** | **depth**                                  | **Comments**                                                                                                                                                             |
+===========+============================================+==========================================================================================================================================================================+
| 0         |                                            | We always begin with the empty set.                                                                                                                                      |
+-----------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 1         | ``(0, b), (0, d), (0, e)``                 | The nodes with no children have depth 0. The recursive step for **a** and **c** fails to produce a value, since some of their children do not have values for ``depth``. |
+-----------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 2         | ``(0, b), (0, d), (0, e), (1, c)``         | The recursive step for **c** succeeds, since ``depth`` now has a value for all its children (**d** and **e**). The recursive step for **a** still fails.                 |
+-----------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 3         | ``(0, b), (0, d), (0, e), (1, c), (2, a)`` | The recursive step for **a** succeeds, since ``depth`` now has a value for all its children (**b** and **c**).                                                           |
+-----------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Here we can see that at the intermediate stages it is very important for the aggregate to fail if some of the children lack a value - this prevents erroneous values being added.

Aggregate variants
------------------

Strict aggregates
~~~~~~~~~~~~~~~~~

The aggregates ``strictsum`` and ``strictcount`` are known as "strict" aggregates. This means that if there are no possible assignments to the aggregation variables that satisfy the range, then the aggregate fails to produce any values, instead of defaulting to zero (which is the behavior of ``sum`` and ``count``). This is useful if you're only interested in cases where the range of the aggregate is valid. For example, the query:

.. code-block:: ql

   from Employee e
   select e, sum(Project p | e.getAProject() = p | p.costToDate())

produces zeros for employees who have no projects. This may just clutter up the results, whereas:

.. code-block:: ql

   from Employee e
   select e, strictsum(Project p | e.getAProject() = p | p.costToDate())

will only produce results for employees who actually have projects.

Rank
~~~~

Rank is a slightly unusual aggregate. It takes the possible values of the expression and ranks them, returning both the value and the corresponding rank. This has some special syntax to assign the rank to a variable. For example, the query:

.. code-block:: ql

   from int salary, int salaryRank
   where salary = rank[salaryRank](Employee e | managedByMe(e) | e.getSalary())
   select salary, salaryRank

assigns, for each of my managees, their salary to ``salary``, and the rank of their salary to ``salaryRank``. In our running example, the results would be:

+------------+----------------+
| ``salary`` | ``salaryRank`` |
+============+================+
| $50k       | 1              |
+------------+----------------+
| $30k       | 3              |
+------------+----------------+

Note that the ranking does not ignore duplicates. Since there are two employees (Alice and Charles) with salary $50k, the two $50k salaries "tie" for first place, and the $30k salary is ranked in third.

If you wanted to rank the employees themselves by salary, you could write the following query:

.. code-block:: ql

   from Employee employee, int salaryRank
   where employee.salary() = rank[salaryRank](Employee e | managedByMe(e) | e.salary())
   select employee, salaryRank order by salaryRank desc

Abbreviated aggregates
~~~~~~~~~~~~~~~~~~~~~~

As we've described them so far, aggregates have three parts: a set of variable declarations, a range, and an expression. However, often it's unnecessarily verbose to write all three, when the intention is clear from context. QL allows you to abbreviate your aggregates in a number of ways.

+---------------------------------------------+---------------------------------------------------+--------------------------------------------------------+------------------------------------------------------------+
| Abbreviated form                            | Equivalent full form                              | Example                                                | Result                                                     |
+=============================================+===================================================+========================================================+============================================================+
| ``aggregate(expression)``                   | ``aggregate(Type var | expression = var | var)``  | ``avg(e.getAProject().getRunTime())``                  | The average run time of the projects belonging to ``e``.   |
+---------------------------------------------+---------------------------------------------------+--------------------------------------------------------+------------------------------------------------------------+
| ``aggregate(Type var, ... | | expression)`` | ``aggregate(Type var, ... | any() | expression)`` | ``min(Employee e | | e.getSalary())``                  | The lowest salary of **any** employee.                     |
+---------------------------------------------+---------------------------------------------------+--------------------------------------------------------+------------------------------------------------------------+
| ``aggregate(Type var)``                     | ``aggregate(Type var | any () | var)``            | ``count(Employee e)``                                  | The total number of employees.                             |
+---------------------------------------------+---------------------------------------------------+--------------------------------------------------------+------------------------------------------------------------+
| ``aggregate(Type var | range)``             | ``aggregate(Type var | range | var)``             | ``count(Employee e | managedByMe(e))``                 | The number of employees managed by you.                    |
+---------------------------------------------+---------------------------------------------------+--------------------------------------------------------+------------------------------------------------------------+
| ``count(Type var, ... | range)``            | ``count(Type var, ... | range | 1)``              | ``count(Employee e1, Employee e2 | e1.worksWith(e2))`` | The number of pairs of employees who work with each other. |
+---------------------------------------------+---------------------------------------------------+--------------------------------------------------------+------------------------------------------------------------+

These abbreviations are valid for any aggregate, except for the last, which is only valid for ``count``.

.. |image0| image:: ../../images/monotonic-aggregates-graph.png

