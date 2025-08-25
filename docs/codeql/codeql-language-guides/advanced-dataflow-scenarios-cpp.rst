.. _advanced-dataflow-scenarios-cpp:

Advanced dataflow scenarios for C/C++
======================================

Data flow for C and C++ distinguishes between the value of a pointer and the value of what the pointer points to. We call this the "indirection" of the pointer. Tracking the pointer and its indirection as separate entities is important for precise dataflow. However, it also means that you need to specify which data flow node to model. If you select the wrong data flow node, then analysis will be flawed. This article discusses several scenarios where it is important to consider whether data flow should be computed on the value of the pointer or its indirection.

Overview
---------

For almost all situations we only need to instantiate a dataflow configuration and specify our sources and sinks, and the dataflow library will handle everything for us.

However, when a write to a field is not visible to CodeQL (for example, because it happens in a function whose definition is not in the database) we need to track the qualifier, and tell the dataflow library that it should transfer flow from the qualifier to the field access. This is done by adding an ``isAdditionalFlowStep`` predicate to the dataflow module.

When you write additional flow steps to track pointers, you must decide whether the dataflow step should flow from the pointer or its indirection. Similarly, you must decide whether the additional step should target a pointer or its indirection.

In contrast, if the read of a field is not visible to CodeQL, you can add an ``allowImplicitRead`` predicate to model the data flow.

Regular dataflow analysis
-------------------------

Consider the following scenario: We have data coming out of ``user_input()`` and we want to figure out if that data can ever reach an argument of ``sink``.

.. code-block:: cpp

  void sink(int);
  int user_input();

A regular dataflow query such as the following query:

.. code-block:: ql

  /**
  * @kind path-problem
  */

  import semmle.code.cpp.dataflow.new.DataFlow
  import Flow::PathGraph

  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(Call).getTarget().hasName("user_input")
    }

    predicate isSink(DataFlow::Node sink) {
      exists(Call call |
        call.getTarget().hasName("sink") and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }

  module Flow = DataFlow::Global<Config>;

  from Flow::PathNode source, Flow::PathNode sink
  where Flow::flowPath(source, sink)
  select sink.getNode(), source, sink, "Flow from user input to sink!"

will catch most things such as:

.. code-block:: cpp
  :caption: Example 1
  :linenos:

  struct A {
    const int *p;
    int x;
  };

  struct B {
    A *a;
    int y;
  };

  void fill_structure(B* b, const int* pu) {
    // ...
    b->a->p = pu;
  }

  void process_structure(const B* b) {
    sink(*b->a->p);
  }

  void get_and_process() {
    int u = user_input();
    B* b = (B*)malloc(sizeof(B));
    // ...
    fill_structure(b, &u);
    // ...
    process_structure(b);
    free(b);
  }

This data flow is simple to match because the CodeQL database contains the information to see:
  1. User input starts at ``user_input()`` and flows into ``fill_structure``.
  2. The data is written to the object ``b`` with access path ``[a, p]``.
  3. The object ``b`` flows out of ``fill_structure`` and into ``process_structure``.
  4. The access path ``[a, p]`` is read in ``process_structure`` and the value ends up in the sink.

Flow from a qualifier to a field access
---------------------------------------

Sometimes field accesses are not visible to CodeQL (for example, because the implementation of the function isn't included in the database), and so dataflow cannot match up all stores with reads. This leads to missing (false negative) results.

For example, consider an alternative setup where our source of data starts as the outgoing argument of a function ``write_user_input_to``. We can model this setup in the dataflow library using the following ``isSource``:

.. code-block:: ql

  predicate isSource(DataFlow::Node source) {
    exists(Call call |
      call.getTarget().hasName("write_user_input_to") and
      source.asDefiningArgument() = call.getArgument(0)
    )
  }

This would match the call to ``write_user_input_to`` in the following example:

.. code-block:: cpp
  :caption: Example 2
  :linenos:

  void write_user_input_to(void*);
  void use_value(int);
  void* malloc(unsigned long);

  struct U {
    const int* p;
    int x;
  };

  void process_user_data(const int* p) {
    // ...
    use_value(*p);
  }

  void get_and_process_user_input_v2() {
    U* u = (U*)malloc(sizeof(U));
    write_user_input_to(u);
    process_user_data(u->p);
    free(u);
  }

With this definition of ``isSource`` the dataflow library tracks flow along the following path:

  1. The flow now starts at the outgoing argument of ``write_user_input_to(...)``.
  2. The flow proceeds to ``u->p`` on the next line.

However, because CodeQL has not observed a write to ``p`` before the read ``u->p``, dataflow will stop at ``u``. We can correct this gap in the information available to dataflow by adding an additional flow step through field reads:

.. code-block:: ql

  /**
  * @kind path-problem
  */

  import semmle.code.cpp.dataflow.new.DataFlow
  import Flow::PathGraph

  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists(Call call |
        call.getTarget().hasName("write_user_input_to") and
        source.asDefiningArgument() = call.getArgument(0)
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(Call call |
        call.getTarget().hasName("use_value") and
        sink.asExpr() = call.getAnArgument()
      )
    }

    predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(FieldAccess fa |
        n1.asIndirectExpr() = fa.getQualifier() and
        n2.asIndirectExpr() = fa
      )
    }
  }

  module Flow = DataFlow::Global<Config>;

  from Flow::PathNode source, Flow::PathNode sink
  where Flow::flowPath(source, sink)
  select sink.getNode(), source, sink, "Flow from user input to sink!"

Notice how the ``isSource`` and ``isSink`` are as expected: we're looking for flow that starts at the outgoing parameter of ``write_user_input_to(...)``, and ends up as an argument to ``isSink``. The interesting part is the addition of ``isAdditionalFlow`` which specifies an additional flow step from the qualifier of a ``FieldAccess`` to the result of the access.

In a real query the ``isAdditionalFlowStep`` step would be restricted in various ways to make sure that it doesn't add too much flow (since flow from a field qualifier to the field access in general will generate a lot of spurious flow). For example, one could restrict ``fa`` to be a field access that targets a particular field, or a field access of a field that's defined in a certain ``struct`` type.

We have an important choice here: Should ``n2`` be the node corresponding to the pointer value of ``fa`` or the indirection of ``fa`` (that is, what ``fa`` points to)?

.. _using-asIndirectExpr:

Using asIndirectExpr
~~~~~~~~~~~~~~~~~~~~

If we use ``n2.asIndirectExpr() = fa`` we specify that flow in example 2 moves to what ``fa`` points to. This allows data to flow through a later dereference, which is exactly what we need to track data flow from ``p`` to ``*p`` in ``process_user_data``.

Thus we get the required flow path.

Consider a slightly different sink:

.. code-block:: cpp
  :caption: Example 3
  :linenos:

  void write_user_input_to(void*);
  void use_pointer(int*);
  void* malloc(unsigned long);

  struct U {
    const int* p;
    int x;
  };

  void process_user_data(const int* p) {
    // ...
    use_pointer(p);
  }

  void get_and_process_user_input_v2() {
    U* u = (U*)malloc(sizeof(U));
    write_user_input_to(u);
    process_user_data(u->p);
    free(u);
  }

The only difference between the previous example and this one is that our data ends up in a call to ``use_pointer`` which takes an ``int*`` instead of an ``int`` as an argument. Since our ``isAdditionalFlowStep`` implementation already steps to the indirection of the ``FieldAccess`` we're already tracking what the field points to. So we can find this flow by using ``sink.asIndirectExpr()`` to specify that the data we're interested in tracking is the value that ends up being pointed to by an argument that is passed to ``use_pointer``:

.. code-block:: ql

  predicate isSink(DataFlow::Node sink) {
    exists(Call call |
      call.getTarget().hasName("use_pointer") and
      sink.asIndirectExpr() = call.getAnArgument()
    )
  }

.. _using-asExpr:

Using asExpr
~~~~~~~~~~~~

Alternatively, the flow in example 2 could also be tracked by:
  1. Changing ``isAdditionalFlowStep`` so that it targets the dataflow node that represents the value of the ``FieldAccess`` instead of the value it points to, and
  2. Changing ``isSink`` to specify that we're interested in tracking the value the argument passed to ``use_pointer`` (instead of the value of what the argument points to).

With those changes our query becomes:

.. code-block:: ql

  /**
  * @kind path-problem
  */

  import semmle.code.cpp.dataflow.new.DataFlow
  import Flow::PathGraph

  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists(Call call |
        call.getTarget().hasName("write_user_input_to") and
        source.asDefiningArgument() = call.getArgument(0)
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(Call call |
        call.getTarget().hasName("use_pointer") and
        sink.asExpr() = call.getAnArgument()
      )
    }

    predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(FieldAccess fa |
        n1.asIndirectExpr() = fa.getQualifier() and
        n2.asExpr() = fa
      )
    }
  }

  module Flow = DataFlow::Global<Config>;

  from Flow::PathNode source, Flow::PathNode sink
  where Flow::flowPath(source, sink)
  select sink.getNode(), source, sink, "Flow from user input to sink!"

When we get to ``u->p`` the additional step transfers flow from what the qualifier points to, to the result of the ``FieldAccess``. After this, dataflow proceeds to ``p`` in ``use_pointer(p)`` and since we specified in our ``isSink`` that we're interested in the value of the argument, our dataflow analysis finds a result.

Passing the address of a variable to ``use_pointer``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Consider an alternative scenario where ``U`` contains a single ``int`` data, and we pass the address of data to ``use_pointer`` as seen below.

.. code-block:: cpp
  :caption: Example 4
  :linenos:

  void write_user_input_to(void*);
  void use_pointer(int*);
  void* malloc(unsigned long);

  struct U {
    int data;
    int x;
  };

  void process_user_data(int data) {
    // ...
    use_pointer(&data);
  }


  void get_and_process_user_input_v2() {
    U* u = (U*)malloc(sizeof(U));
    write_user_input_to(u);
    process_user_data(u->data);
    free(u);
  }

Since the ``data`` field is now an ``int`` instead of an ``int*`` the field no longer has any indirections, and so the use of ``asIndirectExpr`` in ``isAdditionalFlowStep`` no longer makes sense (and so the additional step will have no results). So there is no choice about whether to taint the value of the field or its indirection: it has to be the value.

However, since we pass the address of ``data`` to ``use_pointer`` on line 12 the tainted value is what is pointed to by the argument of ``use_pointer`` (since the value pointed to by ``&data`` is exactly ``data``). So to handle this case we need a mix of the two situations above:
  1. We need to taint the value of the field as described in the :ref:`Using asExpr <using-asExpr>` section.
  2. We need to select the indirection of the argument as described in the :ref:`Using asIndirectExpr <using-asIndirectExpr>` section.

With these changes the query looks like:

.. code-block:: ql

  /**
  * @kind path-problem
  */

  import semmle.code.cpp.dataflow.new.DataFlow
  import Flow::PathGraph

  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists(Call call |
        call.getTarget().hasName("write_user_input_to") and
        source.asDefiningArgument() = call.getArgument(0)
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(Call call |
        call.getTarget().hasName("use_pointer") and
        sink.asIndirectExpr() = call.getAnArgument()
      )
    }

    predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(FieldAccess fa |
        n1.asIndirectExpr() = fa.getQualifier() and
        n2.asExpr() = fa
      )
    }
  }

  module Flow = DataFlow::Global<Config>;

  from Flow::PathNode source, Flow::PathNode sink
  where Flow::flowPath(source, sink)
  select sink.getNode(), source, sink, "Flow from user input to sink!"

And with that query the flow is identified.

Specifying implicit reads
-------------------------

The previous section demonstrated how to add flow from qualifiers to field accesses because a source implicitly tainted all the fields of a struct. This section considers the opposite scenario: A specific field is being tainted, and we want to find any place that may read from this object, including any place that reads an unknown set of fields.

To set the stage, consider the following scenario:

.. code-block:: cpp
  :caption: Example 5
  :linenos:

  struct A {
    const int *p;
    int x;
  };

  struct B {
    A *a;
    int z;
  };

  int user_input();
  void read_data(const void *);
  void *malloc(size_t);

  void get_input_and_read_data() {
    B b;
    b.a = (A *)malloc(sizeof(A));
    b.a->x = user_input();
    // ...
    read_data(&b);
    free(b.a);
  }

In this example, the data flows as follows:

  1. We write a user-controlled value into the object ``b`` at the access path ``[a, x]``.
  2. Afterwards, ``b`` is passed to ``read_data`` which we don't have the definition of in the database.

We now want to track this user-input flowing into ``read_data``.

The dataflow library has a specific predicate to handle this scenario, and thus we don't need to add any additional flow steps using ``isAdditionalFlowStep``. Instead, we tell the dataflow library that ``read_data`` is a sink and may implicitly read the data from fields in the object it is passed. To do that, we implement ``allowImplicitRead`` in our dataflow module:

.. code-block:: ql

  /**
  * @kind path-problem
  */

  import semmle.code.cpp.dataflow.new.DataFlow
  import Flow::PathGraph

  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists(Call call |
        call.getTarget().hasName("user_input") and
        source.asExpr() = call
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(Call call |
        call.getTarget().hasName("read_data") and
        sink.asIndirectExpr() = call.getAnArgument()
      )
    }

    predicate allowImplicitRead(DataFlow::Node n, DataFlow::ContentSet cs) {
      isSink(n) and
      cs.getAReadContent().(DataFlow::FieldContent).getField().hasName(["a", "x"])
    }
  }

  module Flow = DataFlow::Global<Config>;

  from Flow::PathNode source, Flow::PathNode sink
  where Flow::flowPath(source, sink)
  select sink.getNode(), source, sink, "Flow from user input to sink!"

The ``allowImplicitRead`` predicate specifies that if we're at a node that satisfies ``isSink`` then we're allowed to assume that there is an implicit read of a field named ``a`` or a field named ``x`` (in this case both). This gets us the flow we are interested in because the dataflow library now will see:

  1. User input starts at ``user_input()``.
  2. The data flowing into ``b`` with access path ``[a, x]``.
  3. The data flowing to the indirection of ``&b`` (i.e., the object ``b``).
  4. An implicit read of the field ``x`` followed by an implicit read of the field ``a`` at the sink.

Thus, we end up at a node that satisfies ``isSink`` with an empty access path, and successfully track the full dataflow path.
