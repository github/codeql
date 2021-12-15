.. _javadoc:

Javadoc
=======

You can use CodeQL to find errors in Javadoc comments in Java code.

About analyzing Javadoc
-----------------------

To access Javadoc associated with a program element, we use member predicate ``getDoc`` of class ``Element``, which returns a ``Documentable``. Class ``Documentable``, in turn, offers a member predicate ``getJavadoc`` to retrieve the Javadoc attached to the element in question, if any.

Javadoc comments are represented by class ``Javadoc``, which provides a view of the comment as a tree of ``JavadocElement`` nodes. Each ``JavadocElement`` is either a ``JavadocTag``, representing a tag, or a ``JavadocText``, representing a piece of free-form text.

The most important member predicates of class ``Javadoc`` are:

-  ``getAChild`` - retrieves a top-level ``JavadocElement`` node in the tree representation.
-  ``getVersion`` - returns the value of the ``@version`` tag, if any.
-  ``getAuthor`` - returns the value of the ``@author`` tag, if any.

For example, the following query finds all classes that have both an ``@author`` tag and a ``@version`` tag, and returns this information:

.. code-block:: ql

   import java

   from Class c, Javadoc jdoc, string author, string version
   where jdoc = c.getDoc().getJavadoc() and
       author = jdoc.getAuthor() and
       version = jdoc.getVersion()
   select c, author, version

``JavadocElement`` defines member predicates ``getAChild`` and ``getParent`` to navigate up and down the tree of elements. It also provides a predicate ``getTagName`` to return the tag's name, and a predicate ``getText`` to access the text associated with the tag.

We could rewrite the above query to use this API instead of ``getAuthor`` and ``getVersion``:

.. code-block:: ql

   import java
    
   from Class c, Javadoc jdoc, JavadocTag authorTag, JavadocTag versionTag
   where jdoc = c.getDoc().getJavadoc() and
       authorTag.getTagName() = "@author" and authorTag.getParent() = jdoc and
       versionTag.getTagName() = "@version" and versionTag.getParent() = jdoc
   select c, authorTag.getText(), versionTag.getText()

The ``JavadocTag`` has several subclasses representing specific kinds of Javadoc tags:

-  ``ParamTag`` represents ``@param`` tags; member predicate ``getParamName`` returns the name of the parameter being documented.
-  ``ThrowsTag`` represents ``@throws`` tags; member predicate ``getExceptionName`` returns the name of the exception being documented.
-  ``AuthorTag`` represents ``@author`` tags; member predicate ``getAuthorName`` returns the name of the author.

Example: Finding spurious @param tags
-------------------------------------

As an example of using the CodeQL Javadoc API, let's write a query that finds ``@param`` tags that refer to a non-existent parameter.

For example, consider this program:

.. code-block:: java

   class A {
       /**
       * @param lst a list of strings
       */
       public String get(List<String> list) {
           return list.get(0);
       }
   }

Here, the ``@param`` tag on ``A.get`` misspells the name of parameter ``list`` as ``lst``. Our query should be able to find such cases.

To begin with, we write a query that finds all callables (that is, methods or constructors) and their ``@param`` tags:

.. code-block:: ql

   import java

   from Callable c, ParamTag pt
   where c.getDoc().getJavadoc() = pt.getParent()
   select c, pt

It's now easy to add another conjunct to the ``where`` clause, restricting the query to ``@param`` tags that refer to a non-existent parameter: we simply need to require that no parameter of ``c`` has the name ``pt.getParamName()``.

.. code-block:: ql

   import java

   from Callable c, ParamTag pt
   where c.getDoc().getJavadoc() = pt.getParent() and
       not c.getAParameter().hasName(pt.getParamName())
   select pt, "Spurious @param tag."

Example: Finding spurious @throws tags
--------------------------------------

A related, but somewhat more involved, problem is finding ``@throws`` tags that refer to an exception that the method in question cannot actually throw.

For example, consider this Java program:

.. code-block:: java

   import java.io.IOException;

   class A {
       /**
       * @throws IOException thrown if some IO operation fails
       * @throws RuntimeException thrown if something else goes wrong
       */
       public void foo() {
           // ...
       }
   }

Notice that the Javadoc comment of ``A.foo`` documents two thrown exceptions: ``IOException`` and ``RuntimeException``. The former is clearly spurious: ``A.foo`` doesn't have a ``throws IOException`` clause, and therefore can't throw this kind of exception. On the other hand, ``RuntimeException`` is an unchecked exception, so it can be thrown even if there is no explicit ``throws`` clause listing it. So our query should flag the ``@throws`` tag for ``IOException``, but not the one for ``RuntimeException.``

Remember that the CodeQL library represents ``@throws`` tags using class ``ThrowsTag``. This class doesn't provide a member predicate for determining the exception type that is being documented, so we first need to implement our own version. A simple version might look like this:

.. code-block:: ql

   RefType getDocumentedException(ThrowsTag tt) {
       result.hasName(tt.getExceptionName())
   }

Similarly, ``Callable`` doesn't come with a member predicate for querying all exceptions that the method or constructor may possibly throw. We can, however, implement this ourselves by using ``getAnException`` to find all ``throws`` clauses of the callable, and then use ``getType`` to resolve the corresponding exception types:

.. code-block:: ql

   predicate mayThrow(Callable c, RefType exn) {
       exn.getASupertype*() = c.getAnException().getType()
   }

Note the use of ``getASupertype*`` to find both exceptions declared in a ``throws`` clause and their subtypes. For instance, if a method has a ``throws IOException`` clause, it may throw ``MalformedURLException``, which is a subtype of ``IOException``.

Now we can write a query for finding all callables ``c`` and ``@throws`` tags ``tt`` such that:

-  ``tt`` belongs to a Javadoc comment attached to ``c``.
-  ``c`` can't throw the exception documented by ``tt``.

.. code-block:: ql

   import java

   // Insert the definitions from above

   from Callable c, ThrowsTag tt, RefType exn
   where c.getDoc().getJavadoc() = tt.getParent+() and
       exn = getDocumentedException(tt) and
       not mayThrow(c, exn)
   select tt, "Spurious @throws tag."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1258570917227966396/>`__. This finds several results in the LGTM.com demo projects.

Improvements
~~~~~~~~~~~~

Currently, there are two problems with this query:

#. ``getDocumentedException`` is too liberal: it will return *any* reference type with the right name, even if it's in a different package and not actually visible in the current compilation unit.
#. ``mayThrow`` is too restrictive: it doesn't account for unchecked exceptions, which do not need to be declared.

To see why the former is a problem, consider this program:

.. code-block:: java

   class IOException extends Exception {}

   class B {
       /** @throws IOException an IO exception */
       void bar() throws IOException {}
   }

This program defines its own class ``IOException``, which is unrelated to the class ``java.io.IOException`` in the standard library: they are in different packages. Our ``getDocumentedException`` predicate doesn't check packages, however, so it will consider the ``@throws`` clause to refer to both ``IOException`` classes, and thus flag the ``@param`` tag as spurious, since ``B.bar`` can't actually throw ``java.io.IOException``.

As an example of the second problem, method ``A.foo`` from our previous example was annotated with a ``@throws RuntimeException`` tag. Our current version of ``mayThrow``, however, would think that ``A.foo`` can't throw a ``RuntimeException``, and thus flag the tag as spurious.

We can make ``mayThrow`` less restrictive by introducing a new class to represent unchecked exceptions, which are just the subtypes of ``java.lang.RuntimeException`` and ``java.lang.Error``:

.. code-block:: ql

   class UncheckedException extends RefType {
       UncheckedException() {
           this.getASupertype*().hasQualifiedName("java.lang", "RuntimeException") or
           this.getASupertype*().hasQualifiedName("java.lang", "Error")
       }
   }

Now we incorporate this new class into our ``mayThrow`` predicate:

.. code-block:: ql

   predicate mayThrow(Callable c, RefType exn) {
       exn instanceof UncheckedException or
       exn.getASupertype*() = c.getAnException().getType()
   }

Fixing ``getDocumentedException`` is more complicated, but we can easily cover three common cases:

#. The ``@throws`` tag specifies the fully qualified name of the exception.
#. The ``@throws`` tag refers to a type in the same package.
#. The ``@throws`` tag refers to a type that is imported by the current compilation unit.

The first case can be covered by changing ``getDocumentedException`` to use the qualified name of the ``@throws`` tag. To handle the second and the third case, we can introduce a new predicate ``visibleIn`` that checks whether a reference type is visible in a compilation unit, either by virtue of belonging to the same package or by being explicitly imported. We then rewrite ``getDocumentedException`` as:

.. code-block:: ql

   predicate visibleIn(CompilationUnit cu, RefType tp) {
       cu.getPackage() = tp.getPackage()
       or
       exists(ImportType it | it.getCompilationUnit() = cu | it.getImportedType() = tp)
   }

   RefType getDocumentedException(ThrowsTag tt) {
       result.getQualifiedName() = tt.getExceptionName()
       or
       (result.hasName(tt.getExceptionName()) and visibleIn(tt.getFile(), result))
   }

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8016848987103345329/>`__. This finds many fewer, more interesting results in the LGTM.com demo projects.

Currently, ``visibleIn`` only considers single-type imports, but you could extend it with support for other kinds of imports.

Further reading
---------------

.. include:: ../reusables/java-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
