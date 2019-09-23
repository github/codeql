River crossing puzzle
#####################

The aim of this tutorial is to write a QL query that finds a solution to the following classical logic puzzle:

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
sure that you are familiar with how to define `classes <https://help.semmle.com/QL/ql-handbook/classes.html>`__
and `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__ in QL.
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
      :lines: 15-22

Second, any item can be on one of two shores. Let's call these the "left shore" and the "right shore".
Define a class ``Shore`` containing ``"Left"`` and ``"Right"``.

It would be helpful to express "the other shore". You can do this by defining a member predicate
``other`` in the class ``Shore`` such that ``"Left".other()`` returns ``"Right"`` and vice versa.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :lines: 25-38

We also want a way to keep track of where the man, the goat, the cabbage, and the wolf are—call this combined
information the "state". Define a class ``State`` that encodes this information.
For example, if the man is on the left shore, the goat on the right shore, and the cabbage and wolf on the left
shore, the state should be ``Left, Right, Left, Left``.

You may find it helpful to introduce some variables that refer to the shore on which the man and the cargo items are. These
temporary variables in the body of a class are called `fields <https://help.semmle.com/QL/ql-handbook/types.html#fields>`__.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing-1.ql
      :lines: 33-43,84

We are interested in two particular states, namely the initial state and the goal state.
Assuming that all items start on the left shore and end up on the right shore, define
``InitialState`` and ``GoalState`` as subclasses of ``State``.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing-1.ql
      :lines: 86-94

.. pull-quote::

   Note

   To avoid typing out the lengthy string concatenations, you could introduce a helper predicate
   ``renderState`` that renders the state in the required form.

Using the above note, the QL code so far looks like this:

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :lines: 14-55,100-110

Model the action of "ferrying"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The basic act of ferrying moves the man and a cargo item to the other shore,
resulting in a new state.

Write a member predicate (of ``State``) called ``ferry``, that specifies what happens to the state
after ferrying a particular cargo. (Hint: Use the predicate ``other``.)

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :lines: 57-66

Of course, not all ferrying actions are possible. Add some extra conditions to describe when a ferrying
action is "safe", that is, it doesn't lead to a state where the goat or the cabbage get eaten.
For example, follow these steps:

   #. Define a predicate ``eats`` that encodes the conditions for when a "predator" is able to eat an
      unguarded "prey".
   #. Define a predicate ``isSafe`` that holds when nothing gets eaten.
   #. Define a predicate ``safeFerry`` that restricts ``ferry`` to only include safe ferrying actions.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :lines: 68-78

Find paths from one state to another
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The main aim of this query is to find a path, that is, a list of successive ferrying actions, to get
from one state to another.

When finding the path, you should be careful to avoid "infinite" solutions. For example, the man
could ferry the goat back and forth any number of times without ever reaching an unsafe state.

One way to restrict to finite solutions is to define a `member predicate <https://help.semmle.com/QL/ql-handbook/types.html#member-predicates>`__
``State reachesVia(string path, int steps)``.
The result of this predicate is any state that is reachable from the current state (``this``) via
the given path in a specified finite number of steps.

You can write this as a `recursive predicate <https://help.semmle.com/QL/ql-handbook/recursion.html>`__,
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
      :lines: 67-83

However, although this ensures that the solution is finite, it can still contain loops if the upper bound
for ``steps`` is large.

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
    there is an `index of <https://help.semmle.com/QL/ql-spec/language.html#built-ins-for-string>`__
    ``visitedStates`` at which the state occurs.)

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :lines: 80-99

Display the results
~~~~~~~~~~~~~~~~~~~

Once you've defined all the necessary classes and predicates, write a `select clause <https://help.semmle.com/QL/ql-handbook/queries.html#select-clauses>`__
that returns the resulting path.

.. container:: toggle

   .. container:: name

      *Show/hide code*

   .. literalinclude:: river-crossing.ql
      :lines: 112-114

For now, the path defined in the above predicate ``reachesVia`` just lists the order of cargo items to ferry.
You could tweak the predicates and the select clause to make the solution clearer. Here are some suggestions:

  - Display more information, such as the direction in which the cargo is ferried, for example
    ``"Goat to the left shore"``.
  - Fully describe the state at every step, for example ``"Goat: Left, Man: Left, Cabbage: Right, Wolf: Right"``.
  - Display the path in a more "visual" way, for example by using arrows to display the transitions between states.

.. _alternatives:

Alternative solutions
---------------------

Here are some more example QL queries that solve the river crossing puzzle:

  - Solutions described in more detail: https://lgtm.com/query/4550752404102766320/
  - Solutions displayed in a more visual way: https://lgtm.com/query/5824364611285694673/

.. TODO: Add more examples

