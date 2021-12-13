# CodeQL workshop for C/C++: Predicates and classes

In this next part of the workshop, we will experiment with refactoring this query using different features of CodeQL. There are no exercises in this section.

## Existential quantifiers

 The first feature we will explore is _existential quantifiers_. Although the terminology may sound scary if you are not familiar with logic and logic programming, these are simply ways to introduce temporary variables with some associated conditions. The syntax for them is:
```
exists(<variable declarations> | <formula>)
```
They have a similar structure to the `from` and `where` clauses, where the first part allows you to declare one or more variables, and the second formula ("conditions") that can be applied to those formula.

For example, we can use this to refactor our query to use a temporary variable for the empty block:
```ql
from IfStmt ifStmt
where
  exists(Block block |
    ifStmt.getThen() = block and
    block.getNumStmt() = 0
  )
select ifStmt, "Empty if statement"
```

## Predicates

The next feature we will explore is _predicates_. These provide a way to encapsulate portions of logic in the program so that they can be reused. Like existential quantifiers, you can think of them as a mini `from`-`where`-`select` query clause. Like a select clause they also produce a set of "tuples" or rows in a result table.

We can introduce a new predicate in our query that identifies the set of empty blocks in the program (for example, to reuse this feature in another query):

```ql
predicate isEmptyBlock(Block block) {
  block.getNumStmt() = 0
}

from IfStmt ifStmt
where isEmptyBlock(ifStmt.getThen())
select ifStmt, "Empty if statement"
```

You can define a predicate with result by replacing the keyword predicate with the type of the result. This introduces the special variable `result`, which can be used like a regular parameter.

```ql
Block getAnEmptyBlock() {
  result.getNumStmt() = 0
}
```
From an implementation point of view, this is effectively equivalent to the previous predicate:
```ql
predicate getAnEmptyBlock(Block result) {
  result.getNumStmt() = 0
}
```
The main difference is how we use it:
```ql
from IfStmt ifStmt
where ifStmt.getThen() = getAnEmptyBlock()
select ifStmt, "Empty if statement"
```
The predicate is an expression, and so can be used for equality comparisons. However, both forms of predicate calculate the same set of values under the hood.

## Classes

In this final part of the workshop we will talk about CodeQL classes. Classes are a way in which you can define new types within CodeQL, as well as providing an easy way to reuse and structure code.

Like all types in CodeQL, classes represent a set of values. For example, the `Block` type is, in fact, a class, and it represents the set of all blocks in the program. You can also think of a class as defining a set of logical conditions that specifies the set of values for that class.

For example, we can define a new CodeQL class to represent empty blocks:
```ql
class EmptyBlock extends Block {
  EmptyBlock() {
    this.getNumStmt() = 0
  }
}
```
We use the keyword `class`, provide a name for our class, then provide a "super-type". All classes in QL must have at least one super-type, and the super-types define the initial set of values in our class. In this case, our `EmptyBlock` starts with all the values in the `Block` class. However, a class that can only represent the same set of values as another class is not very interesting. We can therefore provide a _characteristic predicate_ that defines some additional conditions that can restrict the set of values further. In this case, we can specify the same condition as before to indicate that our empty blocks are blocks whose `getNumStmt() = 0`. We can use the special variable `this` to refer to the instance of `Block` we are constraining.

 Note that a value can belong to more than one of these sets, which means that it can have more than one type. For example, empty blocks are both `Block`s and `EmptyBlocks`.

So far, this class is actually equivalent to the predicate solutions we saw above - we are in fact specifying the same conditions, and this will calculate the same set of values. The difference, again, is how we use it:
```ql
from IfStmt ifStmt, EmptyBlock block
where ifStmt.getThen() = block
select ifStmt, "Empty if statement"
```
This is another instance of the proscriptive typing of QL - by changing the type of the variable to `EmptyBlock`, we change the meaning of the program.

As discussed previously, classes can also provide operations. These operations are called _member predicates_, as they are predicates which are members of the class. For example:
```ql
class MyBlock extends Block {
  predicate isEmptyBlock() {
    this.getNumStmt() = 0
  }
}
```
In this case we are not going to provide a characteristic predicate - this class is going to represent the same set of values as `Block`. However, we will provide a member predicate is specify whether this is an empty block. Member predicates also have a special variable called `this` which refers to the instance.

We can then use this in the same way as operations provided on standard library classes:
```ql
from IfStmt ifStmt, MyBlock block
where
  ifStmt.getThen() = block and
  block.isEmptyBlock()
select ifStmt, "Empty if statement"
```
In fact, this is how the standard library classes are implemented - if we select `getThen()`, we can see it is also defined as a member predicate.
