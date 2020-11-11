.. _using-type-tracking-for-api-modeling:

Using type tracking for API modeling
====================================

You can track data through an API by creating a model using the CodeQL type-tracking library for JavaScript.

Overview
--------
The type-tracking library makes it possible to track values through properties and function calls,
usually to recognize method calls and properties accessed on a specific type of object.

This is an advanced topic and is intended for readers already familiar with the
`SourceNode <analyzing-data-flow-in-javascript.html#source-nodes>`__ class as well as
`taint tracking <analyzing-data-flow-in-javascript.html#using-global-analyzing-data-flow-and-tracking-tainted-data-in-python>`__.
For TypeScript analysis also consider reading about `static type information <codeql-library-for-typescript.html.html#static-type-information>`__ first.


The problem of recognizing method calls
---------------------------------------

We'll start with a simple model of the `Firebase API <https://firebase.google.com/docs/reference/js/firebase.database>`__ and gradually build on it to use type tracking.
Knowledge of Firebase is not required.

Suppose we wish to find places where data is written to a Firebase database, as
in the following example:

.. code-block:: javascript

  var ref = firebase.database().ref("forecast");
  ref.set("Rain"); // <-- find this call

A simple way to do this is just to find
all method calls named "``set``":

.. code-block:: ql

  import javascript
  import DataFlow

  MethodCallNode firebaseSetterCall() {
    result.getMethodName() = "set"
  }

The obvious problem with this is that it finds calls to *all* methods named ``set``,
many of which are unrelated to Firebase.

Another approach is to use local data flow to match the chain of calls that led to this call:

.. code-block:: ql

  MethodCallNode firebaseSetterCall() {
    result = globalVarRef("firebase")
        .getAMethodCall("database")
        .getAMethodCall("ref")
        .getAMethodCall("set")
  }

This will find the ``set`` call from the example, but no spurious, unrelated ``set`` method calls.
We can split it up so each step is its own predicate:

.. code-block:: ql

  SourceNode firebase() {
    result = globalVarRef("firebase")
  }

  SourceNode firebaseDatabase() {
    result = firebase().getAMethodCall("database")
  }

  SourceNode firebaseRef() {
    result = firebaseDatabase().getAMethodCall("ref");
  }

  MethodCallNode firebaseSetterCall() {
    result = firebaseRef().getAMethodCall("set")
  }

The code above is equivalent to the previous version,
but it's easier to tinker with the individual steps.

The downside is that the model relies entirely on local data flow,
which means it won't look through properties and function calls.
For instance, ``firebaseSetterCall()`` fails to find anything in this example:

.. code-block:: javascript

  function getDatabase() {
    return firebase.database();
  }
  var ref = getDatabase().ref("forecast");
  ref.set("Rain");

Notice that the predicate ``firebaseDatabase()`` still finds the call to ``firebase.database()``,
but not the ``getDatabase()`` call.
This means ``firebaseRef()`` has no result, which in turn means ``firebaseSetterCall()`` has no result.

As a simple remedy, let's try to make ``firebaseDatabase()`` recognize the ``getDatabase()`` call:

.. code-block:: ql

  SourceNode firebaseDatabase() {
    result = firebase().getAMethodCall("database")
    or
    result.(CallNode).getACallee().getAReturn().getALocalSource() = firebaseDatabase()
  }

The second clause ensures ``firebaseDatabase()`` finds not only ``firebase.database()`` calls,
but also calls to functions that *return* ``firebase.database()``, such as ``getDatabase()`` seen above.
It's recursive, so it handles flow out of any number of nested function calls.

However, it still only tracks *out* of functions, not *into* functions through parameters, nor through properties.
Instead of adding these steps by hand, we'll use type tracking.

Type tracking in general
------------------------

Type tracking is a generalization of the above pattern, where a predicate matches the value to track,
and has a recursive clause that tracks the flow of that value.
But instead of us having to deal with function calls/returns and property reads/writes,
all of these steps are included in a single predicate,
`SourceNode.track <https://help.semmle.com/qldoc/javascript/semmle/javascript/dataflow/Sources.qll/predicate.Sources$SourceNode$track.2.html>`__,
to be used with the companion class
`TypeTracker <https://help.semmle.com/qldoc/javascript/semmle/javascript/dataflow/TypeTracking.qll/type.TypeTracking$TypeTracker.html>`__.

Predicates that use type tracking usually conform to the following general pattern, which we explain below:

.. code-block:: ql

  SourceNode myType(TypeTracker t) {
    t.start() and
    result = /* SourceNode to track */
    or
    exists(TypeTracker t2 |
      result = myType(t2).track(t2, t)
    )
  }

  SourceNode myType() {
    result = myType(TypeTracker::end())
  }

We'll apply the pattern to our example model and use that to explain what's going on.


Tracking the database instance
------------------------------

Applying the above pattern to the ``firebaseDatabase()`` predicate we get the following:

.. code-block:: ql

  SourceNode firebaseDatabase(TypeTracker t) {
    t.start() and
    result = firebase().getAMethodCall("database")
    or
    exists(TypeTracker t2 |
      result = firebaseDatabase(t2).track(t2, t)
    )
  }

  SourceNode firebaseDatabase() {
    result = firebaseDatabase(TypeTracker::end())
  }

There are now two predicates named ``firebaseDatabase``.
The one with the ``TypeTracker`` parameter is the one actually doing the global data flow tracking
-- the other predicate exposes the result in a convenient way.

The new ``TypeTracker t`` parameter is a summary of the steps needed to track the value of interest to the resulting data flow node.

In the base case, when matching ``firebase.database()``, we use ``t.start()`` to indicate that no steps were needed, that is,
this is the starting point of type tracking:

.. code-block:: ql

  t.start() and
  result = firebase().getAMethodCall("database")

In the recursive case, we apply the ``track`` predicate on a previously-found Firebase database node, such as ``firebase.database()``.
The ``track`` predicate maps this to a successor of that node, such as ``getDatabase()``, and
binds ``t`` to the continuation of ``t2`` with this extra step included:

.. code-block:: ql

  exists(TypeTracker t2 |
    result = firebaseDatabase(t2).track(t2, t)
  )

To understand the role of ``t`` here, note that type tracking can step *into* a property, which means
the data flow node returned from ``track`` is not necessarily a Firebase database instance, it could be
an object *containing* a Firebase database in one of its properties.

For example, in the program below, the ``firebaseDatabase(t)`` predicate includes the ``obj`` node in its result,
but with ``t`` recording the fact that the actual value being tracked is inside the ``DB`` property:

.. code-block:: javascript

  let obj = { DB: firebase.database() };
  let db = obj.DB;

This brings us to the last predicate. This uses ``TypeTracker::end()`` to filter out
the paths where the Firebase database instance ended up inside a property of another object,
so it includes ``db`` but not ``obj``:

.. code-block:: ql

  SourceNode firebaseDatabase() {
    result = firebaseDatabase(TypeTracker::end())
  }

Here's see an example of what this can handle now:

.. code-block:: javascript

  class Firebase {
    constructor() {
      this.db = firebase.database();
    }

    getDatabase() { return this.db; }

    setForecast(value) {
      this.getDatabase().ref("forecast").set(value); // found by firebaseSetterCall()
    }
  }

Tracking in the whole model
---------------------------
We applied this pattern to ``firebaseDatabase()`` in the previous section, and it
can just as easily apply to the other predicates.
For reference, here's our simple Firebase model with type tracking on every predicate:

.. code-block:: ql

  SourceNode firebase(TypeTracker t) {
    t.start() and
    result = globalVarRef("firebase")
    or
    exists(TypeTracker t2 |
      result = firebase(t2).track(t2, t)
    )
  }

  SourceNode firebase() {
    result = firebase(TypeTracker::end())
  }

  SourceNode firebaseDatabase(TypeTracker t) {
    t.start() and
    result = firebase().getAMethodCall("database")
    or
    exists(TypeTracker t2 |
      result = firebaseDatabase(t2).track(t2, t)
    )
  }

  SourceNode firebaseDatabase() {
    result = firebaseDatabase(TypeTracker::end())
  }

  SourceNode firebaseRef(TypeTracker t) {
    t.start() and
    result = firebaseDatabase().getAMethodCall("ref")
    or
    exists(TypeTracker t2 |
      result = firebaseRef(t2).track(t2, t)
    )
  }

  SourceNode firebaseRef() {
    result = firebaseRef(TypeTracker::end())
  }

  MethodCallNode firebaseSetterCall() {
    result = firebaseRef().getAMethodCall("set")
  }

`Here <https://lgtm.com/query/1053770500827789481>`__ is a run of an example query using the model to find `set` calls on one of the Firebase sample projects.
It's been modified slightly to handle a bit more of the API, which is beyond the scope of this tutorial.

Tracking associated data
------------------------

By adding extra parameters to the type-tracking predicate, we can carry along
extra bits of information about the result.

For example, here's a type-tracking version of ``firebaseRef()``, which
tracks the string that was passed to the ``ref`` call:

.. code-block:: ql

  SourceNode firebaseRef(string name, TypeTracker t) {
    t.start() and
    exists(CallNode call |
      call = firebaseDatabase().getAMethodCall("ref") and
      name = call.getArgument(0).getStringValue() and
      result = call
    )
    or
    exists(TypeTracker t2 |
      result = firebaseRef(name, t2).track(t2, t)
    )
  }

  SourceNode firebaseRef(string name) {
    result = firebaseRef(name, TypeTracker::end())
  }

  MethodCallNode firebaseSetterCall(string refName) {
    result = firebaseRef(refName).getAMethodCall("set")
  }

So now we can use ``firebaseSetterCall("forecast")`` to find assignments to the forecast.

Back-tracking callbacks
-----------------------

The type-tracking predicates we've seen above all use *forward* tracking.
That is, they all start with some value of interest and ask "where does this flow?".

Sometimes it's more useful to work backwards, starting at the desired end-point and asking "what flows to here?".

As a motivating example, we'll extend our model to look for places where we *read* a value
from the database, as opposed to writing it.
Reading is an asynchronous operation and the result is obtained through a callback, for example:

.. code-block:: javascript

  function fetchForecast(callback) {
    firebase.database().ref("forecast").once("value", callback);
  }

  function updateReminders() {
    fetchForecast((snapshot) => {
      let forecast = snapshot.val(); // <-- find this call
      addReminder(forecast === "Rain" ? "Umbrella" : "Sunscreen");
    })
  }

The actual forecast is obtained by the call to ``snapshot.val()``.

Looking for all method calls named ``val`` will in practice find many unrelated methods,
so we'll use type tracking again to take the receiver type into account.

The receiver ``snapshot`` is a parameter to a callback function, which ultimately escapes
into the ``once()`` call. We'll extend our model from above to use back-tracking to find
all functions that flow into the ``once()`` call.
Backwards type tracking is not too different from forwards type tracking. The differences are:

- The ``TypeTracker`` parameter instead has type ``TypeBackTracker``.
- The call to ``.track()`` is instead a call to ``.backtrack()``.
- To ensure the initial value is a source node, a call to ``getALocalSource()`` is usually required.

.. code-block:: ql

  SourceNode firebaseSnapshotCallback(string refName, TypeBackTracker t) {
    t.start() and
    result = firebaseRef(refName).getAMethodCall("once").getArgument(1).getALocalSource()
    or
    exists(TypeBackTracker t2 |
      result = firebaseSnapshotCallback(refName, t2).backtrack(t2, t)
    )
  }

  FunctionNode firebaseSnapshotCallback(string refName) {
    result = firebaseSnapshotCallback(refName, TypeBackTracker::end())
  }

Now, ``firebaseSnapshotCallback("forecast")`` finds the function being passed to ``fetchForecast``.
Based on that we can track the ``snapshot`` value and find the ``val()`` call itself:

.. code-block:: ql

  SourceNode firebaseSnapshot(string refName, TypeTracker t) {
    t.start() and
    result = firebaseSnapshotCallback(refName).getParameter(0)
    or
    exists(TypeTracker t2 |
      result = firebaseSnapshot(refName, t2).track(t2, t)
    )
  }

  SourceNode firebaseSnapshot(string refName) {
    result = firebaseSnapshot(refName, TypeTracker::end())
  }

  MethodCallNode firebaseDatabaseRead(string refName) {
    result = firebaseSnapshot(refName).getAMethodCall("val")
  }

With this addition, ``firebaseDatabaseRead("forecast")`` finds the call to ``snapshot.val()`` that contains the value of the forecast.

`Here <https://lgtm.com/query/8761360814276109092>`__ is a run of an example query using the model to find `val` calls.

Summary
-------

We have covered how to use the type-tracking library. To recap, use this template to define forward type-tracking predicates:

.. code-block:: ql

  SourceNode myType(TypeTracker t) {
    t.start() and
    result = /* SourceNode to track */
    or
    exists(TypeTracker t2 |
      result = myType(t2).track(t2, t)
    )
  }

  SourceNode myType() {
    result = myType(TypeTracker::end())
  }

Use this template to define backward type-tracking predicates:

.. code-block:: ql

  SourceNode myType(TypeBackTracker t) {
    t.start() and
    result = (/* argument to track */).getALocalSource()
    or
    exists(TypeBackTracker t2 |
      result = myType(t2).backtrack(t2, t)
    )
  }

  SourceNode myType() {
    result = myType(TypeBackTracker::end())
  }

Note that these predicates all return ``SourceNode``,
so attempts to track a non-source node, such as an identifier or string literal,
will not work.
If this becomes an issue, see
`TypeTracker.smallstep <https://help.semmle.com/qldoc/javascript/semmle/javascript/dataflow/TypeTracking.qll/predicate.TypeTracking$TypeTracker$smallstep.2.html>`__.

Also note that the predicates taking a ``TypeTracker`` or ``TypeBackTracker`` can often be made ``private``,
as they are typically only used as an intermediate result to compute the other predicate.

Limitations
-----------

As mentioned, type tracking will track values in and out of function calls and properties,
but only within some limits.

For example, type tracking does not always track *through* functions. That is, if a value flows into a parameter
and back out of the return value, it might not be tracked back out to the call site again.
Here's an example that the model from this tutorial won't find:

.. code-block:: javascript

  function wrapDB(database) {
    return { db: database }
  }
  let wrapper = wrapDB(firebase.database())
  wrapper.db.ref("forecast"); // <-- not found

This is an example of where `data-flow configurations <analyzing-data-flow-in-javascript.html#global-data-flow>`__ are more powerful.

When to use type tracking
-------------------------

Type tracking and data-flow configurations are different solutions to the same
problem, each with their own tradeoffs.

Type tracking can be used in any number of predicates, which may depend on each other
in fairly unrestricted ways. The result of one predicate may be the starting
point for another. Type-tracking predicates may be mutually recursive.
Type-tracking predicates can have any number of extra parameters, making it possible, but optional,
to construct source/sink pairs. Omitting source/sink pairs can be useful when there is a huge number
of sources and sinks.

Data-flow configurations have more restricted dependencies but are more powerful in other ways.
For performance reasons,
the sources, sinks, and steps of a configuration should not depend on whether a flow path has been found using
that configuration or any other configuration.
In that sense, the sources, sinks, and steps must be configured "up front" and can't be discovered on-the-fly.
The upside is that they track flow through functions and callbacks in some ways that type tracking doesn't,
which is particularly important for security queries.
Also, path queries can only be defined using data-flow configurations.

Prefer type tracking when:

- Disambiguating generically named methods or properties.
- Making reusable library components to be shared between queries.
- The set of source/sink pairs is too large to compute or has insufficient information.
- The information is needed as input to a data-flow configuration.

Prefer data-flow configurations when:

- Tracking user-controlled data -- use `taint tracking <analyzing-data-flow-in-javascript.html#using-global-analyzing-data-flow-and-tracking-tainted-data-in-python>`__.
- Differentiating between different kinds of user-controlled data -- see ":doc:`Using flow labels for precise data flow analysis <using-flow-labels-for-precise-data-flow-analysis>`."
- Tracking transformations of a value through generic utility functions.
- Tracking values through string manipulation.
- Generating a path from source to sink -- see ":ref:`Creating path queries <creating-path-queries>`."

Lastly, depending on the code base being analyzed, some alternatives to consider are:

- Using `static type information <codeql-library-for-typescript.html.html#static-type-information>`__,
  if analyzing TypeScript code.

- Relying on local data flow.

- Relying on syntactic heuristics such as the name of a method, property, or variable.

Type tracking in the standard libraries
---------------------------------------

Type tracking is used in a few places in the standard libraries:

- The `DOM <https://help.semmle.com/qldoc/javascript/semmle/javascript/DOM.qll/module.DOM$DOM.html>`__ predicates,
  `documentRef <https://help.semmle.com/qldoc/javascript/semmle/javascript/DOM.qll/predicate.DOM$DOM$documentRef.0.html>`__,
  `locationRef <https://help.semmle.com/qldoc/javascript/semmle/javascript/DOM.qll/predicate.DOM$DOM$locationRef.0.html>`__, and
  `domValueRef <https://help.semmle.com/qldoc/javascript/semmle/javascript/DOM.qll/predicate.DOM$DOM$domValueRef.0.html>`__,
  are implemented with type tracking.
- The `HTTP <https://help.semmle.com/qldoc/javascript/semmle/javascript/frameworks/HTTP.qll/module.HTTP$HTTP.html>`__ server models, such as `Express <https://help.semmle.com/qldoc/javascript/semmle/javascript/frameworks/Express.qll/module.Express$Express.html>`__, use type tracking to track the installation of router handler functions.
- The `Firebase <https://help.semmle.com/qldoc/javascript/semmle/javascript/frameworks/Firebase.qll/module.Firebase$Firebase.html>`__ and
  `Socket.io <https://help.semmle.com/qldoc/javascript/semmle/javascript/frameworks/SocketIO.qll/module.SocketIO$SocketIO.html>`__ models use type tracking to track objects coming from their respective APIs.

Further reading
---------------

.. include:: ../../reusables/javascript-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
