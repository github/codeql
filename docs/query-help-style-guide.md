# Query help style guide

## Introduction

When you contribute a new [supported query](supported-queries.md) to this repository, or add a custom query for analysis in LGTM, you should also write a query help file. This file provides detailed information about the purpose and use of the query, which is available to users in LGTM (for example [here](https://lgtm.com/rules/1506093386171/)) and on the query homepages:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

### Location and file name

Query help files must have the same base name as the query they describe and must be located in the same directory.  

### File structure and layout

Query help files are written using a custom XML format, and stored in a file with a `.qhelp` extension. The basic structure is as follows:

```
<!DOCTYPE qhelp SYSTEM "qhelp.dtd">
<qhelp>
    CONTAINS one or more section-level elements
</qhelp>
```

The header and single top-level `<qhelp>` element are both mandatory. 

### Section-level elements

Section-level elements are used to group the information within the query help file. All query help files should include at least the following section elements, in the order specified:

1.  `overview`—a short summary of the issue that the query identifies, including an explanation of how it could affect the behavior of the program.
2.  `recommendation`—information on how to fix the issue highlighted by the query.
3.  `example`—an example of code showing the problem. Where possible, this section should also include a solution to the issue.
4.  `references`—relevant references, such as authoritative sources on language semantics and best practice. 

For further information about the other section-level, block, list and table elements supported by query help files, see [Query help files](https://help.semmle.com/QL/learn-ql/ql/writing-queries/query-help.html) on help.semmle.com.


## English style

You should write the overview and recommendation elements in simple English that is easy to follow. You should:

*   Use simple sentence structures and avoid complex or academic language.
*   Avoid colloquialisms and contractions.
*   Use US English spelling throughout.
*   Use words that are in common usage.

## Code examples

Whenever possible, you should include a code example that helps to explain the issue you are highlighting. Any code examples that you include should adhere to the following guidelines:

*   The example should be less than 20 lines, but it should still clearly illustrate the issue that the query identifies.  If appropriate, then the example may also be runnable.
*   Put the code example after the recommendation element where possible. Only include an example in the description element if absolutely necessary.
*   If you are using an example to illustrate the solution to a problem, and the change required is minor, avoid repeating the whole example. It is preferable to either describe the change required or to include a smaller snippet of the corrected code.
*   Clearly indicate which of the samples is an example of bad coding practice and which is recommended practice.
*   Define the code examples in `src` files. The language is inferred from the file extension:

```
<example>
<p>This example highlights poor coding practice</p>

<sample src = "example-code-bad.java" />

<p>This example shows how to fix the code</p>

<sample src = "example-code-fixed.java" />
</example>
```

Note, if any code words are included in the `overview` and `recommendation` sections, they should be formatted with `<code> ... </code>` for emphasis.

## Including references

You should include one or more references, list formatted with `<li> ... </li>` for each item, to provide further information about the problem that your query is designed to find. References can be of the following types:

### Books

If you are citing a book, use the following format:

>\<Author-initial. Surname>, _\<Book title>_ \<page/chapter etc.\>, \<Publisher\>, \<date\>.

For example:

>W. C. Wake, _Refactoring Workbook_, pp. 93 – 94, Addison-Wesley Professional, 2004.

Note, & symbols need to be replaced by \&amp;. The symbol will be displayed correctly in the HTML files generated from the query help files.

### Academic papers

If you are citing an academic paper, we recommend adopting the reference style of the journal that you are citing. For example: 

>S. R. Chidamber and C. F. Kemerer, _A metrics suite for object-oriented design_. IEEE Transactions on Software Engineering, 20(6):476-493, 1994.


### Websites

If you are citing a website, please use the following format, without breadcrumb trails:

>\<Name of website>: \<Name of page or anchor>

For example:

>Java 6 API Specification: [Object.clone()](http://docs.oracle.com/javase/6/docs/api/java/lang/Object.html#clone%28%29).

### Referencing potential security weaknesses

If your query checks code for a CWE weakness, you should use the `@tags` element in the query file to reference the associated CWEs, as explained [here](query-metadata-style-guide.md). When you use these tags, a link to the appropriate entry from the [MITRE.org](https://cwe.mitre.org/scoring/index.html) site will automatically appear as a reference in the output HTML file.

## Query help example 

The following example is a query help file for a query from the standard query suite for Java: 

```
<!DOCTYPE qhelp PUBLIC
  "-//Semmle//qhelp//EN"
  "qhelp.dtd">
<qhelp>

<overview>
<p>A control structure (an <code>if</code> statement or a loop) has a body that is either a block
of statements surrounded by curly braces or a single statement.</p>

<p>If you omit braces, it is particularly important to ensure that the indentation of the code
matches the control flow of the code.</p>

</overview>
<recommendation>

<p>It is usually considered good practice to include braces for all control
structures in Java. This is because it makes it easier to maintain the code
later. For example, it's easy to see at a glance which part of the code is in the
scope of an <code>if</code> statement, and adding more statements to the body of the <code>if</code>
statement is less error-prone.</p>

<p>You should also ensure that the indentation of the code is consistent with the actual flow of 
control, so that it does not confuse programmers.</p>

</recommendation>
<example>

<p>In the example below, the original version of <code>Cart</code> is missing braces. This means 
that the code triggers a <code>NullPointerException</code> at runtime if <code>i</code>
is <code>null</code>.</p>

<sample src="UseBraces.java" />

<p>The corrected version of <code>Cart</code> does include braces, so
that the code executes as the indentation suggests.</p>

<sample src="UseBracesGood.java" />

<p>
In the following example the indentation may or may not be misleading depending on your tab width
settings. As such, mixing tabs and spaces in this way is not recommended, since what looks fine in
one context can be very misleading in another.
</p>

<sample src="UseBraces2.java" />

<p>
If you mix tabs and spaces in this way, then you might get seemingly false positives, since your
tab width settings cannot be taken into account.
</p>

</example>
<references>

<li>
  Java SE Documentation:
  <a href="http://www.oracle.com/technetwork/java/javase/documentation/codeconventions-142311.html#15395">Compound Statements</a>.
</li>
<li>
  Wikipedia:
  <a href="https://en.wikipedia.org/wiki/Indent_style">Indent style</a>.
</li>

</references>
</qhelp>
```
