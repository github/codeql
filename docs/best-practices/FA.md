# FA (Frequent Annoyances)

## There are many syntactic constructs that do the same thing

  Possible solutions:
  Description | Used by
  --- | ---
  Desugar as much as possible | Ruby
  A properties library | Python
  A guards library | C#, Java
  An intermediate representation (IR) | C++

## Method resolution is imprecise

  Possible solutions:
  Description | Used by
  --- | ---
  Type tracking (makes up for missing type system) | Javascript, Python, Ruby
  Several passes of SSA | C#

## Line numbers change in my `.expected`-file, when I add a new test case

  Possible solutions:
  Description | Used by
  --- | ---
  Inline expectations | Everyone?
