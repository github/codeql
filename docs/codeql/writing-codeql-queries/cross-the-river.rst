.. _cross-the-river:

Cross the river
===============

Use common QL features to write a query that finds a solution to the "River crossing" logic puzzle.

Introduction
------------

.. pull-quote::

   River crossing puzzle

   A man is trying to ferry a goat, a cabbage, and a wolf across a river.
   His boat can only take himself and at most one item as cargo.
   His problem is that if the goat is left alone with the cabbage, it will eat it.
   And if the wolf is left alone with the goat, it will eat it.
   How does he get everything across the river?

A solution should be a set of instructions for how to ferry the items, such as "First ferry the goat
across the river, and come back with nothing. Then ferry the cabbage across, and come back with ..."

There are lots of ways to approach this problem and implement it in QL. Before you start, make
sure that you are familiar with how to define :ref:`classes <classes>`
and :ref:`predicates <predicates>` in QL.
The following walkthrough is just one of many possible implementations, so have a go at writing your
own query too! To find more example queries, see the list :ref:`below <alternatives>`.

Walkthrough
-----------

Model the elements of the puzzle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The basic components of the puzzle are the cargo items and the shores on either side of the river.
Start by modeling these as classes.

First, define a class ``Cargo`` containing the different cargo items.
Note that the man can also travel on his own, so it helps to explicitly include ``"Nothing"`` as
a piece of cargo.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 15-23

Second, any item can be on one of two shores. Let's call these the "left shore" and the "right shore".
Define a class ``Shore`` containing ``"Left"`` and ``"Right"``.

It would be helpful to express "the other shore" to model moving from one side of the river to the other.
You can do this by defining a member predicate
``other`` in the class ``Shore`` such that ``"Left".other()`` returns ``"Right"`` and vice versa.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 25-38

We also want a way to keep track of where the man, the goat, the cabbage, and the wolf are at any point. We can call this combined
information the "state". Define a class ``State`` that encodes the location of each piece of cargo.
For example, if the man is on the left shore, the goat on the right shore, and the cabbage and wolf on the left
shore, the state should be ``Left, Right, Left, Left``.

You may find it helpful to introduce some variables that refer to the shore on which the man and the cargo items are. These
temporary variables in the body of a class are called :ref:`fields <fields>`.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing-1.ql
      :language: ql
      :lines: 33-40,87

We are interested in two particular states, namely the initial state and the goal state,
which we have to achieve to solve the puzzle.
Assuming that all items start on the left shore and end up on the right shore, define
``InitialState`` and ``GoalState`` as subclasses of ``State``.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing-1.ql
      :language: ql
      :lines: 89-97

.. pull-quote::

   Note

   To avoid typing out the lengthy string concatenations, you could introduce a helper predicate
   ``renderState`` that renders the state in the required form.

Using the above note, the QL code so far looks like this:

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 15-52,103-113

Model the action of "ferrying"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The basic act of ferrying moves the man and one cargo item to the other shore,
resulting in a new state.

Write a member predicate (of ``State``) called ``ferry``, that specifies what happens to the state
after ferrying a particular cargo. (Hint: Use the predicate ``other``.)

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 54-67

Of course, not all ferrying actions are possible. Add some extra conditions to describe when a ferrying
action is "safe". That is, it doesn't lead to a state where the goat or the cabbage get eaten.
For example, follow these steps:

   #. Define a predicate ``isSafe`` that holds when the state itself is safe. Use this to encode the
      conditions for when nothing gets eaten.
   #. Define a predicate ``safeFerry`` that restricts ``ferry`` to only include safe ferrying actions.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 69-81

Find paths from one state to another
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The main aim of this query is to find a path, that is, a list of successive ferrying actions, to get
from the initial state to the goal state. You could write this "list" by separating each item by a
newline (``"\n"``).

When finding the solution, you should be careful to avoid "infinite" paths. For example, the man
could ferry the goat back and forth any number of times without ever reaching an unsafe state.
Such a path would have an infinite number of river crossings without ever solving the puzzle.

One way to restrict our paths to a finite number of river crossings is to define a 
:ref:`member predicate <member-predicates>`
``State reachesVia(string path, int steps)``.
The result of this predicate is any state that is reachable from the current state (``this``) via
the given path in a specified finite number of steps.

You can write this as a :ref:`recursive predicate <recursion>`,
with the following base case and recursion step:

  - If ``this`` *is* the result state, then it (trivially) reaches the result state via an
    empty path in zero steps.
  - Any other state is reachable if ``this`` can reach an intermediate state (for some value of
    ``path`` and ``steps``), and there is a ``safeFerry`` action from that intermediate
    state to the result state.

To ensure that the predicate is finite, you should restrict ``steps`` to a particular value,
for example ``steps <= 7``.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing-1.ql
      :language: ql
      :lines: 70-86

However, although this ensures that the solution is finite, it can still contain loops if the upper bound
for ``steps`` is large. In other words, you could get an inefficient solution by revisiting the same state
multiple times.

Instead of picking an arbitrary upper bound for the number of steps, you can avoid
counting steps altogether. If you keep track of states that have already been visited and ensure
that each ferrying action leads to a new state, the solution certainly won't contain any loops.

To do this, change the member predicate to ``State reachesVia(string path, string visitedStates)``.
The result of this predicate is any state that is reachable from the current state (``this``) via
the given path without revisiting any previously visited states.

  - As before, if ``this`` *is* the result state, then it (trivially) reaches the result state via an
    empty path and an empty string of visited states.
  - Any other state is reachable if  ``this`` can reach an intermediate state via some path, without
    revisiting any previous states, and there is a ``safeFerry`` action from the intermediate state to
    the result state.
    (Hint: To check whether a state has previously been visited, you could check if
    there is an `index of <https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#built-ins-for-string>`__
    ``visitedStates`` at which the state occurs.)

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 83-102

Display the results
~~~~~~~~~~~~~~~~~~~

Once you've defined all the necessary classes and predicates, write a :ref:`select clause <select-clauses>`
that returns the resulting path.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :language: ql
      :lines: 115-117

The :ref:`don't-care expression <don-t-care-expressions>` (``_``),
as the second argument to the ``reachesVia`` predicate, represents any value of ``visitedStates``.

For now, the path defined in ``reachesVia`` just lists the order of cargo items to ferry.
You could tweak the predicate and the select clause to make the solution clearer. Here are some suggestions:

  - Display more information, such as the direction in which the cargo is ferried, for example
    ``"Goat to the left shore"``.
  - Fully describe the state at every step, for example ``"Goat: Left, Man: Left, Cabbage: Right, Wolf: Right"``.
  - Display the path in a more "visual" way, for example by using arrows to display the transitions between states.

.. _alternatives:

Alternative solutions
---------------------

Here are some more example queries that solve the river crossing puzzle:

  #. This query uses a modified ``path`` variable to describe the resulting path in
     more detail.

     ➤ `See solution in the query console on LGTM.com <https://lgtm.com/query/659603593702729237/>`__

  #. This query models the man and the cargo items in a different way, using an 
     :ref:`abstract <abstract>`
     class and predicate. It also displays the resulting path in a more visual way.

     ➤ `See solution in the query console on LGTM.com <https://lgtm.com/query/1025323464423811143/>`__

  #. This query introduces :ref:`algebraic datatypes <algebraic-datatypes>`
     to model the situation, instead of defining everything as a subclass of ``string``.

     ➤ `See solution in the query console on LGTM.com <https://lgtm.com/query/7260748307619718263/>`__

Further reading
---------------

.. include:: ../reusables/codeql-ref-tools-further-reading.rst
