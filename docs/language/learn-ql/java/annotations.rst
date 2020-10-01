Annotations in Java
===================

CodeQL databases of Java projects contain information about all annotations attached to program elements.

About working with annotations
------------------------------

Annotations are represented by these CodeQL classes:

-  The class ``Annotatable`` represents all entities that may have an annotation attached to them (that is, packages, reference types, fields, methods, and local variables).
-  The class ``AnnotationType`` represents a Java annotation type, such as ``java.lang.Override``; annotation types are interfaces.
-  The class ``AnnotationElement`` represents an annotation element, that is, a member of an annotation type.
-  The class ``Annotation`` represents an annotation such as ``@Override``; annotation values can be accessed through member predicate ``getValue``.

For example, the Java standard library defines an annotation ``SuppressWarnings`` that instructs the compiler not to emit certain kinds of warnings:

.. code-block:: java

   package java.lang;

   public @interface SuppressWarnings {
       String[] value;
   }

``SuppressWarnings`` is represented as an ``AnnotationType``, with ``value`` as its only ``AnnotationElement``.

A typical usage of ``SuppressWarnings`` would be this annotation for preventing a warning about using raw types:

.. code-block:: java

   class A {
       @SuppressWarnings("rawtypes")
       public A(java.util.List rawlist) {
       }
   }

The expression ``@SuppressWarnings("rawtypes")`` is represented as an ``Annotation``. The string literal ``"rawtypes"`` is used to initialize the annotation element ``value``, and its value can be extracted from the annotation by means of the ``getValue`` predicate.

We could then write this query to find all ``@SuppressWarnings`` annotations attached to constructors, and return both the annotation itself and the value of its ``value`` element:

.. code-block:: ql

   import java

   from Constructor c, Annotation ann, AnnotationType anntp
   where ann = c.getAnAnnotation() and
       anntp = ann.getType() and
       anntp.hasQualifiedName("java.lang", "SuppressWarnings")
   select ann, ann.getValue("value")

➤ `See the full query in the query console on LGTM.com <https://lgtm.com/query/1775658606775222283/>`__. Several of the LGTM.com demo projects use the ``@SuppressWarnings`` annotation. Looking at the ``value``\ s of the annotation element returned by the query, we can see that the *apache/activemq* project uses the ``"rawtypes"`` value described above.

As another example, this query finds all annotation types that only have a single annotation element, which has name ``value``:

.. code-block:: ql

   import java

   from AnnotationType anntp
   where forex(AnnotationElement elt |
       elt = anntp.getAnAnnotationElement() |
       elt.getName() = "value"
   )
   select anntp

➤ `See the full query in the query console on LGTM.com <https://lgtm.com/query/2145264152490258283/>`__.

Example: Finding missing ``@Override`` annotations
--------------------------------------------------

In newer versions of Java, it's recommended (though not required) that you annotate methods that override another method with an ``@Override`` annotation. These annotations, which are checked by the compiler, serve as documentation, and also help you avoid accidental overloading where overriding was intended.

For example, consider this example program:

.. code-block:: java

   class Super {
       public void m() {}
   }

   class Sub1 extends Super {
       @Override public void m() {}
   }

   class Sub2 extends Super {
       public void m() {}
   }

Here, both ``Sub1.m`` and ``Sub2.m`` override ``Super.m``, but only ``Sub1.m`` is annotated with ``@Override``.

We'll now develop a query for finding methods like ``Sub2.m`` that should be annotated with ``@Override``, but are not.

As a first step, let's write a query that finds all ``@Override`` annotations. Annotations are expressions, so their type can be accessed using ``getType``. Annotation types, on the other hand, are interfaces, so their qualified name can be queried using ``hasQualifiedName``. Therefore we can implement the query like this:

.. code-block:: ql

   import java

   from Annotation ann
   where ann.getType().hasQualifiedName("java.lang", "Override")
   select ann

As always, it is a good idea to try this query on a CodeQL database for a Java project to make sure it actually produces some results. On the earlier example, it should find the annotation on ``Sub1.m``. Next, we encapsulate the concept of an ``@Override`` annotation as a CodeQL class:

::

   class OverrideAnnotation extends Annotation {
       OverrideAnnotation() {
           this.getType().hasQualifiedName("java.lang", "Override")
       }
   }

This makes it very easy to write our query for finding methods that override another method, but don't have an ``@Override`` annotation: we use predicate ``overrides`` to find out whether one method overrides another, and predicate ``getAnAnnotation`` (available on any ``Annotatable``) to retrieve some annotation.

.. code-block:: ql

   import java

   from Method overriding, Method overridden
   where overriding.overrides(overridden) and
       not overriding.getAnAnnotation() instanceof OverrideAnnotation
   select overriding, "Method overrides another method, but does not have an @Override annotation."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/7419756266089837339/>`__. In practice, this query may yield many results from compiled library code, which aren't very interesting. It's therefore a good idea to add another conjunct ``overriding.fromSource()`` to restrict the result to only report methods for which source code is available.

Example: Finding calls to deprecated methods
--------------------------------------------

As another example, we can write a query that finds calls to methods marked with a ``@Deprecated`` annotation.

For example, consider this example program:

.. code-block:: java

   class A {
       @Deprecated void m() {}

       @Deprecated void n() {
           m();
       }

       void r() {
           m();
       }
   }

Here, both ``A.m`` and ``A.n`` are marked as deprecated. Methods ``n`` and ``r`` both call ``m``, but note that ``n`` itself is deprecated, so we probably should not warn about this call.

As in the previous example, we'll start by defining a class for representing ``@Deprecated`` annotations:

.. code-block:: ql

   class DeprecatedAnnotation extends Annotation {
       DeprecatedAnnotation() {
           this.getType().hasQualifiedName("java.lang", "Deprecated")
       }
   }

Now we can define a class for representing deprecated methods:

.. code-block:: ql

   class DeprecatedMethod extends Method {
       DeprecatedMethod() {
           this.getAnAnnotation() instanceof DeprecatedAnnotation
       }
   }

Finally, we use these classes to find calls to deprecated methods, excluding calls that themselves appear in deprecated methods:

.. code-block:: ql

   import java

   from Call call
   where call.getCallee() instanceof DeprecatedMethod
       and not call.getCaller() instanceof DeprecatedMethod
   select call, "This call invokes a deprecated method."

In our example, this query flags the call to ``A.m`` in ``A.r``, but not the one in ``A.n``.

For more information about the class ``Call``, see ":doc:`Navigating the call graph <call-graph>`."

Improvements
~~~~~~~~~~~~

The Java standard library provides another annotation type ``java.lang.SupressWarnings`` that can be used to suppress certain categories of warnings. In particular, it can be used to turn off warnings about calls to deprecated methods. Therefore, it makes sense to improve our query to ignore calls to deprecated methods from inside methods that are marked with ``@SuppressWarnings("deprecated")``.

For instance, consider this slightly updated example:

.. code-block:: java

   class A {
       @Deprecated void m() {}

       @Deprecated void n() {
           m();
       }

       @SuppressWarnings("deprecated")
       void r() {
           m();
       }
   }

Here, the programmer has explicitly suppressed warnings about deprecated calls in ``A.r``, so our query should not flag the call to ``A.m`` any more.

To do so, we first introduce a class for representing all ``@SuppressWarnings`` annotations where the string ``deprecated`` occurs among the list of warnings to suppress:

.. code-block:: ql

   class SuppressDeprecationWarningAnnotation extends Annotation {
       SuppressDeprecationWarningAnnotation() {
           this.getType().hasQualifiedName("java.lang", "SuppressWarnings") and
           this.getAValue().(Literal).getLiteral().regexpMatch(".*deprecation.*")
       }
   }

Here, we use ``getAValue()`` to retrieve any annotation value: in fact, annotation type ``SuppressWarnings`` only has a single annotation element, so every ``@SuppressWarnings`` annotation only has a single annotation value. Then, we ensure that it is a literal, obtain its string value using ``getLiteral``, and check whether it contains the string ``deprecation`` using a regular expression match.

For real-world use, this check would have to be generalized a bit: for example, the OpenJDK Java compiler allows ``@SuppressWarnings("all")`` annotations to suppress all warnings. We may also want to make sure that ``deprecation`` is matched as an entire word, and not as part of another word, by changing the regular expression to ``".*\\bdeprecation\\b.*"``.

Now we can extend our query to filter out calls in methods carrying a ``SuppressDeprecationWarningAnnotation``:

.. code-block:: ql

   import java

   // Insert the class definitions from above

   from Call call
   where call.getCallee() instanceof DeprecatedMethod
       and not call.getCaller() instanceof DeprecatedMethod
       and not call.getCaller().getAnAnnotation() instanceof SuppressDeprecationWarningAnnotation
   select call, "This call invokes a deprecated method."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8706367340403790260/>`__. It's fairly common for projects to contain calls to methods that appear to be deprecated.

Further reading
---------------

.. include:: ../../reusables/java-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
