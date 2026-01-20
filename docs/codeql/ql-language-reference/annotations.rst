:tocdepth: 1

.. _annotations:

Annotations
###########

An annotation is a string that you can place directly before the declaration of a QL entity or name.

For example, to declare a module ``M`` as private, you could use:

.. code-block:: ql

    private module M {
        ...
    }

Note that some annotations act on an entity itself, whilst others act on a particular *name* for the entity:
  - Act on an **entity**: ``abstract``, ``bindingset``, ``cached``, ``extensible``, ``external``, ``language``,
    ``overlay``, ``override``, ``pragma``, and ``transient``
  - Act on a **name**: ``additional``, ``deprecated``, ``final``, ``library``, ``private``, and ``query``

For example, if you annotate an entity with ``private``, then only that particular name is
private. You could still access that entity under a different name (using an :ref:`alias <aliases>`).
On the other hand, if you annotate an entity with ``cached``, then the entity itself is cached.

Here is an explicit example:

.. code-block:: ql

    module M {
      private int foo() { result = 1 }
      predicate bar = foo/0;
    }

In this case, the query ``select M::foo()`` gives a compiler error, since the name ``foo`` is private.
The query ``select M::bar()`` is valid (giving the result ``1``), since the name ``bar`` is visible
and it is an alias of the predicate ``foo``.

You could apply ``cached`` to ``foo``, but not ``bar``, since ``foo`` is the declaration
of the entity.

.. _annotations-overview:

Overview of annotations
***********************

This section describes what the different annotations do, and when you can use them.
You can also find a summary table in the Annotations section of the 
`QL language specification <https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#annotations>`_.

.. index:: abstract
.. _abstract:

``abstract``
============

**Available for**: |classes|, |member predicates|

The ``abstract`` annotation is used to define an abstract entity.

For information about **abstract classes**, see ":ref:`Classes <abstract-classes>`."

**Abstract predicates** are member predicates that have no body. They can be defined on any 
class, and should be :ref:`overridden <overriding-member-predicates>` in non-abstract subtypes.

Here is an example that uses abstract predicates. A common pattern when writing data flow
analysis in QL is to define a configuration class. Such a configuration must describe, among
other things, the sources of data that it tracks. A supertype of all such configurations might
look like this:

.. code-block:: ql

    abstract class Configuration extends string {
      ...
      /** Holds if `source` is a relevant data flow source. */
      abstract predicate isSource(Node source);
      ...
    }

You could then define subtypes of ``Configuration``, which inherit the predicate ``isSource``,
to describe specific configurations. Any non-abstract subtypes must override it (directly or
indirectly) to describe what sources of data they each track.

In other words, all non-abstract classes that extend ``Configuration`` must override ``isSource`` in their
own body, or they must inherit from another class that overrides ``isSource``:

.. code-block:: ql

    class ConfigA extends Configuration {
      ...
      // provides a concrete definition of `isSource`
      override predicate isSource(Node source) { ... } 
    }
    class ConfigB extends ConfigA {
      ...
      // doesn't need to override `isSource`, because it inherits it from ConfigA
    }

.. index:: additional
.. _additional:

``additional``
==============

**Available for**: |classes|, |algebraic datatypes|, |type unions|, |non-member predicates|, |modules|, |aliases|, |signatures|

The ``additional`` annotation can be used on declarations in explicit modules.
All declarations that are not required by a module signature in modules that implement |module signatures| must be annotated with ``additional``.

Omitting ``additional`` on such declarations, or using the annotation in any other context, will result in a compiler error.
Other than that, the annotation has no effect.

.. index:: cached
.. _cached:

``cached``
==========

**Available for**: |classes|, |algebraic datatypes|, |type unions|, |characteristic predicates|, |member predicates|, |non-member predicates|, |modules|

The ``cached`` annotation indicates that an entity should be evaluated in its entirety and
stored in the evaluation cache. All later references to this entity will use the 
already-computed data. This affects references from other queries, as well as from the current query.

For example, it can be helpful to cache a predicate that takes a long time to evaluate, and is
reused in many places.

You should use ``cached`` carefully, since it may have unintended consequences. For example,
cached predicates may use up a lot of storage space, and may prevent the QL compiler from
optimizing a predicate based on the context at each place it is used. However, this may be a
reasonable tradeoff for only having to compute the predicate once.

If you annotate a class or module with ``cached``, then all non-:ref:`private` entities in its
body must also be annotated with ``cached``, otherwise a compiler error is reported.

.. index:: deprecated
.. _deprecated:

``deprecated``
==============

**Available for**: |classes|, |algebraic datatypes|, |type unions|, |member predicates|, |non-member predicates|, |imports|, |fields|, |modules|, |aliases|, |signatures|

The ``deprecated`` annotation is applied to names that are outdated and scheduled for removal
in a future release of QL.
If any of your QL files use deprecated names, you should consider rewriting them to use newer
alternatives.
Typically, deprecated names have a QLDoc comment that tells users which updated element they
should use instead.

For example, the name ``DataFlowNode`` is deprecated and has the following QLDoc comment:

.. code-block:: ql

    /**
     * DEPRECATED: Use `DataFlow::Node` instead.
     *
     * An expression or function/class declaration, 
     * viewed as a node in a data flow graph.
     */
    deprecated class DataFlowNode extends @dataflownode {
      ...
    }

This QLDoc comment appears when you use the name ``DataFlowNode`` in a QL editor.

.. index:: extensible
.. _extensible:

``extensible``
==============

**Available for**: |non-member predicates|

The ``extensible`` annotation is used to mark predicates that are populated at evaluation time through data extensions.

.. index:: external
.. _external:

``external``
============

**Available for**: |non-member predicates|

The ``external`` annotation is used on predicates, to define an external "template"
predicate. This is similar to a :ref:`database predicate <database-predicates>`.

.. index:: transient
.. _transient:

``transient``
=============
**Available for**: |non-member predicates|

The ``transient`` annotation is applied to non-member predicates that are also annotated with ``external``,
to indicate that they should not be cached to disk during evaluation. Note, if you attempt to apply ``transient`` 
without ``external``, the compiler will report an error.

.. index:: final
.. _final:

``final``
=========

**Available for**: |classes|, |type-aliases|, |member predicates|, |fields|

The ``final`` annotation is applied to names that can't be overridden or extended.
In other words, a final class or a final type alias can't act as a base type for any other types,
and a final predicate or field can't be overridden in a subclass.

This is useful if you don't want subclasses to change the meaning of a particular entity.

For example, the predicate ``hasName(string name)`` holds if an element has the name ``name``. 
It uses the predicate ``getName()`` to check this, and it wouldn't make sense for a subclass to
change this definition. In this case, ``hasName`` should be final:

.. code-block:: ql

    class Element ... {
      string getName() { result = ... }
      final predicate hasName(string name) { name = this.getName() }
    }

.. _library:

``library``
===========

**Available for**: |classes|

.. pull-quote:: Important

   This annotation is deprecated. Instead of annotating a name with ``library``, put it in a
   private (or privately imported) module.

The ``library`` annotation is applied to names that you can only refer to from within a
``.qll`` file.
If you try to refer to that name from a file that does not have the ``.qll`` extension, then the QL
compiler returns an error.

.. index:: override
.. _override:

``override``
============

**Available for**: |member predicates|, |fields|

The ``override`` annotation is used to indicate that a definition :ref:`overrides
<overriding-member-predicates>` a member predicate or field from a base type.

If you override a predicate or field without annotating it, then the QL compiler gives a
warning.

.. index:: private
.. _private:

``private``
===========

**Available for**: |classes|, |algebraic datatypes|, |type unions|, |member predicates|, |non-member predicates|, |imports|, |fields|, |modules|, |aliases|, |signatures|

The ``private`` annotation is used to prevent names from being exported.

If a name has the annotation ``private``, or if it is accessed through an import statement
annotated with ``private``, then you can only refer to that name from within the current 
module's :ref:`namespace <namespaces>`.

.. _query:

``query``
=========

**Available for**: |non-member predicates|, |aliases|

The ``query`` annotation is used to turn a predicate (or a predicate alias) into a :ref:`query`.
This means that it is part of the output of the QL program.

.. index:: pragma
.. _pragma:

Compiler pragmas
================

The following compiler pragmas affect the compilation and optimization of queries. You
should avoid using these annotations unless you experience significant performance issues.

Before adding pragmas to your code, contact GitHub to describe the performance problems.
That way we can suggest the best solution for your problem, and take it into account when
improving the QL optimizer.

Inlining
--------

For simple predicates, the QL optimizer sometimes replaces a :ref:`call <calls>` to a predicate
with the predicate body itself. This is known as **inlining**. 

For example, suppose you have a definition ``predicate one(int i) { i = 1 }``
and a call to that predicate ``... one(y) ...``. The QL optimizer may inline the predicate to
``... y = 1 ...``. 

You can use the following compiler pragma annotations to control the way the QL optimizer inlines 
predicates.

``pragma[inline]``
------------------

**Available for**: |characteristic predicates|, |member predicates|, |non-member predicates|

The ``pragma[inline]`` annotation tells the QL optimizer to always inline the annotated predicate
into the places where it is called. This can be useful when a predicate body is very expensive to 
compute entirely, as it ensures that the predicate is evaluated with the other contextual information
at the places where it is called.

``pragma[inline_late]``
-----------------------

**Available for**: |characteristic predicates|, |member predicates|, |non-member predicates|

The ``pragma[inline_late]`` annotation must be used in conjunction with a
``bindingset[...]`` pragma. Together, they tell the QL optimiser to use the
specified binding set for assessing join orders both in the body of the
annotated predicate and at call sites and to inline the body into call sites
after join ordering. This can be useful to prevent the optimiser from choosing
a sub-optimal join order.

For instance, in the example below, the ``pragma[inline_late]`` and
``bindingset[x]`` annotations specify that calls to ``p`` should be join ordered
in a context where ``x`` is already bound. This forces the join orderer to
order ``q(x)`` before ``p(x)``, which is more computationally efficient
than ordering ``p(x)`` before ``q(x)``.

.. code-block:: ql

	bindingset[x]
	pragma[inline_late]
	predicate p(int x) { x in [0..100000000] }

	predicate q(int x) { x in [0..10000] }

	from int x
	where p(x) and q(x)
	select x

..


``pragma[noinline]``
--------------------

**Available for**: |characteristic predicates|, |member predicates|, |non-member predicates|

The ``pragma[noinline]`` annotation is used to prevent a predicate from being inlined into the
place where it is called. In practice, this annotation is useful when you've already grouped 
certain variables together in a "helper" predicate, to ensure that the relation is evaluated 
in one piece. This can help to improve performance. The QL optimizer's inlining may undo the 
work of the helper predicate, so it's a good idea to annotate it with ``pragma[noinline]``.

``pragma[nomagic]``
-------------------

**Available for**: |characteristic predicates|, |member predicates|, |non-member predicates|

The ``pragma[nomagic]`` annotation is used to prevent the QL optimizer from performing the "magic sets"
optimization on a predicate. 

This kind of optimization involves taking information from the context of a predicate 
:ref:`call <calls>` and pushing it into the body of a predicate. This is usually
beneficial, so you shouldn't use the ``pragma[nomagic]`` annotation unless recommended to do so
by GitHub.

Note that ``nomagic`` implies ``noinline``.

``pragma[noopt]``
-----------------

**Available for**: |characteristic predicates|, |member predicates|, |non-member predicates|

The ``pragma[noopt]`` annotation is used to prevent the QL optimizer from optimizing a
predicate, except when it's absolutely necessary for compilation and evaluation to work.

This is rarely necessary and you should not use the ``pragma[noopt]`` annotation unless
recommended to do so by GitHub, for example, to help resolve performance issues.

When you use this annotation, be aware of the following issues:

#. The QL optimizer automatically orders the conjuncts of a :ref:`complex formula <logical-connectives>`
   in an efficient way. In a ``noopt`` predicate, the conjuncts are evaluated in exactly the order 
   that you write them.
#. The QL optimizer automatically creates intermediary conjuncts to "translate" certain formulas 
   into a :ref:`conjunction <conjunction>` of simpler formulas. In a ``noopt`` predicate, you
   must write these conjunctions explicitly.
   In particular, you can't chain predicate :ref:`calls <calls>` or call predicates on a
   :ref:`cast <casts>`. You must write them as multiple conjuncts and explicitly order them.

   For example, suppose you have the following definitions:

   .. code-block:: ql

       class Small extends int {
         Small() { this in [1 .. 10] }
         Small getSucc() { result = this + 1}
       }
       
       predicate p(int i) {
         i.(Small).getSucc() = 2
       }
       
       predicate q(Small s) {
         s.getSucc().getSucc() = 3
       }
   
   If you add ``noopt`` pragmas, you must rewrite the predicates. For example:

   .. code-block:: ql

       pragma[noopt]
       predicate p(int i) {
         exists(Small s | s = i and s.getSucc() = 2)
       }
       
       pragma[noopt]
       predicate q(Small s) {
         exists(Small succ |
           succ = s.getSucc() and
           succ.getSucc() = 3
         )
       }

``pragma[only_bind_out]``
-------------------------

**Available for**: |expressions|

The ``pragma[only_bind_out]`` annotation lets you specify the direction in which the QL compiler should bind expressions.
This can be useful to improve performance in rare cases where the QL optimizer orders parts of the QL program in an inefficient way.

For example, ``x = pragma[only_bind_out](y)`` is semantically equivalent to ``x = y``, but has different binding behavior. 
``x = y`` binds ``x`` from ``y`` and vice versa, while ``x = pragma[only_bind_out](y)`` only binds ``x`` from ``y``.

For more information, see ":ref:`Binding <binding>`."

``pragma[only_bind_into]``
--------------------------

**Available for**: |expressions|

The ``pragma[only_bind_into]`` annotation lets you specify the direction in which the QL compiler should bind expressions.
This can be useful to improve performance in rare cases where the QL optimizer orders parts of the QL program in an inefficient way.

For example, ``x = pragma[only_bind_into](y)`` is semantically equivalent to ``x = y``, but has different binding behavior. 
``x = y`` binds ``x`` from ``y`` and vice versa, while ``x = pragma[only_bind_into](y)`` only binds ``y`` from ``x``.

For more information, see ":ref:`Binding <binding>`."

``pragma[assume_small_delta]``
------------------------------

**Available for**: |characteristic predicates|, |member predicates|, |non-member predicates|

.. pull-quote:: Important

   This annotation is deprecated.

The ``pragma[assume_small_delta]`` annotation has no effect and can be safely removed.

.. _language:

Language pragmas
================

**Available for**: |modules|, |classes|, |characteristic predicates|, |member predicates|, |non-member predicates|

``language[monotonicAggregates]``
---------------------------------

This annotation allows you to use **monotonic aggregates** instead of the standard QL
:ref:`aggregates <aggregations>`.

For more information, see ":ref:`monotonic-aggregates`."

.. _bindingset:

Binding sets
============

**Available for**: |classes|, |characteristic predicates|, |member predicates|, |non-member predicates|, |predicate signatures|, |type signatures|

``bindingset[...]``
-------------------

You can use this annotation to explicitly state the binding sets for a predicate or class. A binding set
is a subset of a predicate's or class body's arguments such that, if those arguments are constrained to a
finite set of values, then the predicate or class itself is finite (that is, it evaluates to a finite 
set of tuples).

The ``bindingset`` annotation takes a comma-separated list of variables.

- When you annotate a predicate, each variable must be an argument of the predicate, possibly including ``this``
  (for characteristic predicates and member predicates) and ``result`` (for predicates that return a result). 
  For more information, see ":ref:`predicate-binding`."
- When you annotate a class, each variable must be ``this`` or a field in the class. 

.. _overlay:

Overlay annotations
===================

Overlay annotations control how predicates behave during **overlay evaluation**, a feature
that enables efficient incremental analysis of codebases.

In overlay evaluation, a *base database* is created from one version of a codebase, and an
*overlay database* is created by combining the base database with changes from a newer
version (such as a pull request). The goal is to analyze the overlay database as if it
were a fully extracted database at the newer commit, while reusing as much cached data
from the base database as possible. Ideally, analysis time is proportional to the size
of the diff rather than the full codebase.

To achieve this, predicates are divided into *local* and *global* categories, with global
being the default. Local predicates are evaluated independently on base and overlay data,
and thus typically take time proportional to the diff size; global predicates operate on
the combined data, and thus take time proportional to the full codebase. When a global
predicate calls a local predicate, results from both the base and overlay evaluations of
the local predicate are combined, with stale base results filtered out through a process
called "discarding".

Overlay evaluation is primarily used internally by GitHub Code Scanning to speed up
pull request analysis. Most QL developers do not need to use these annotations directly,
but understanding them can help resolve compilation errors that may occur when overlay
support is enabled for a language.

.. note::

   Overlay annotations only affect evaluation when overlay compilation is enabled
   (via ``compileForOverlayEval: true`` in ``qlpack.yml``) and the evaluator is running
   in overlay mode. This setting is typically only needed in the language's library pack;
   custom query packs do not need it. Outside of overlay mode, these annotations are
   validated but have no effect on evaluation.

``overlay[local]``
------------------

**Available for**: |modules|, |classes|, |algebraic datatypes|, |type unions|, |characteristic predicates|, |member predicates|, |non-member predicates|

The ``overlay[local]`` annotation declares that a predicate is local. Local predicates are 
evaluated separately on base and overlay data and may only depend on other local predicates.
The compiler reports an error if a local predicate depends on a global predicate.

.. code-block:: ql

    // All dependencies are database extensionals, so this can be local
    overlay[local]
    predicate stmtInFile(@stmt s, string path) {
      exists(@file f, @location loc |
        hasLocation(s, loc) and
        locations_default(loc, f, _, _, _, _) and
        files(f, path)
      )
    }

``overlay[local?]``
-------------------

**Available for**: |modules|, |classes|, |algebraic datatypes|, |type unions|, |characteristic predicates|, |member predicates|, |non-member predicates|

The ``overlay[local?]`` annotation declares that a predicate should be local if all of
its dependencies are local, and global otherwise. This is particularly useful in
parameterized modules, where different instantiations may have different locality
depending on the module parameters.

.. code-block:: ql

    // Locality depends on whether Expr.getType() and Type.getName() are local
    overlay[local?]
    predicate exprTypeName(Expr e, string name) {
      name = e.getType().getName()
    }

``overlay[global]``
-------------------

**Available for**: |modules|, |classes|, |algebraic datatypes|, |type unions|, |characteristic predicates|, |member predicates|, |non-member predicates|

The ``overlay[global]`` annotation explicitly declares that a predicate is global. This
is the default behavior, so this annotation is typically used to override an inherited
``overlay[local]`` or ``overlay[local?]`` annotation from an enclosing module or class.
See `Annotation inheritance`_ for an example.

``overlay[caller]``
-------------------

**Available for**: |modules|, |classes|, |algebraic datatypes|, |type unions|, |characteristic predicates|, |member predicates|, |non-member predicates|

The ``overlay[caller]`` annotation declares that the locality of a predicate depends on
its caller. The compiler may internally duplicate the predicate, creating separate local
and global versions. Local callers use the local version; global callers use the global
version.

.. code-block:: ql

    overlay[caller]
    predicate utilityPredicate(int x) {
      x in [1..100]
    }

``overlay[caller?]``
--------------------

**Available for**: |modules|, |classes|, |algebraic datatypes|, |type unions|, |characteristic predicates|, |member predicates|, |non-member predicates|

The ``overlay[caller?]`` annotation is like ``overlay[caller]``, but only applies if none
of the predicate's dependencies are global. If any dependency is global, the predicate
becomes global regardless of its callers, and calling it from a local predicate will
result in a compilation error. Like ``overlay[local?]``, this is useful in parameterized
modules where locality may vary between instantiations.

``overlay[discard_entity]``
---------------------------

**Available for**: |non-member predicates| (unary predicates on database types only)

The ``overlay[discard_entity]`` annotation designates an *entity discard predicate*.
These predicates identify database entities that should be filtered out from cached base
results when combining with overlay results during overlay evaluation.

Entity discard predicates must be:

- Unary predicates (taking exactly one argument)
- Defined on a database type (a type from the database schema, prefixed with ``@``)
- Only dependent on local predicates and other non-discarding predicates

.. code-block:: ql

    overlay[discard_entity]
    private predicate discardExpr(@expr e) {
      exists(string file | discardableExpr(file, e) and overlayChangedFiles(file))
    }

    overlay[local]
    private predicate discardableExpr(string file, @expr e) {
      not isOverlay() and
      file = getFile(e)
    }

    overlay[local]
    predicate isOverlay() { databaseMetadata("isOverlay", "true") }

Annotation inheritance
----------------------

Overlay annotations can be applied to modules and types, in which case they are
inherited by enclosed declarations. Declarations without explicit overlay annotations
inherit from their innermost enclosing declaration that has an overlay annotation.

.. code-block:: ql

    overlay[local?]
    module M {
      predicate foo(@expr x) { ... }  // Inherits overlay[local?]

      class C extends @expr {
        predicate bar() { ... }  // Inherits overlay[local?]

        overlay[global]
        predicate baz() { ... }  // Explicitly global
      }
    }

Resolving overlay-related errors
--------------------------------

When overlay support is enabled for a language, you may encounter compilation errors in
custom QL libraries or queries. Here are common errors and their solutions:

**"Declaration is annotated overlay[local] but depends on global entity"**

A predicate marked ``overlay[local]`` (or ``overlay[caller]``) depends on a global predicate.
Solutions:

- Change the annotation to ``overlay[local?]`` (or ``overlay[caller?]``) if the predicate doesn't strictly need to be local
- Add appropriate overlay annotations to the dependency chain to make dependencies local
- Use the ``forceLocal`` higher-order predicate if you need to call global code from local code (advanced)

**"Cannot apply forceLocal to relation that is annotated overlay[...]"**

The ``forceLocal`` higher-order predicate cannot be applied to predicates that have overlay
annotations such as ``overlay[local]``, ``overlay[local?]``, ``overlay[caller]``, or 
``overlay[caller?]``. The input to ``forceLocal`` must be a predicate without such annotations
(i.e., a global predicate or one with ``overlay[global]``).

.. Links to use in substitutions

.. |classes|                   replace:: :ref:`classes <classes>`
.. |characteristic predicates| replace:: :ref:`characteristic predicates <characteristic-predicates>`
.. |member predicates|         replace:: :ref:`member predicates <member-predicates>`
.. |non-member predicates|     replace:: :ref:`non-member predicates <non-member-predicates>`
.. |imports|                   replace:: :ref:`imports <import-statements>`
.. |fields|                    replace:: :ref:`fields <fields>`
.. |modules|                   replace:: :ref:`modules <modules>`
.. |aliases|                   replace:: :ref:`aliases <aliases>`
.. |type-aliases|              replace:: :ref:`type aliases <type-aliases>`
.. |algebraic datatypes|       replace:: :ref:`algebraic datatypes <algebraic-datatypes>`
.. |type unions|               replace:: :ref:`type unions <type-unions>`
.. |expressions|               replace:: :ref:`expressions <expressions>`
.. |signatures|                replace:: :ref:`signatures <signatures>`
.. |predicate signatures|      replace:: :ref:`predicate signatures <predicate-signatures>`
.. |type signatures|           replace:: :ref:`type signatures <type-signatures>`
.. |module signatures|         replace:: :ref:`module signatures <module-signatures>`
