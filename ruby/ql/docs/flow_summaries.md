# Flow summaries

Flow summaries describe how data flows through methods whose definition is not
included in the database. For example, methods in the standard library or a gem.

Say we have the following code:

```rb
x = gets
y = x.chomp
system(y)
```

This code reads a line from STDIN, strips any trailing newlines, and executes it
as a shell command. Assuming `x` is considered tainted, we want the argument `y`
to be tainted in the call to `system`.

`chomp` is a standard library method in the `String` class for which we
have no source code, so we include a flow summary for it:

```ql
private class ChompSummary extends SimpleSummarizedCallable {
  ChompSummary() { this = "chomp" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self]" and
    output = "ReturnValue" and
    preservesValue = false
  }
}
```

The shared dataflow library will use this summary to construct a fake definition
for `chomp`. The behaviour of this definition depends on the body of
`propagatesFlowExt`. In this case, the method will propagate taint flow from the
`self` argument (i.e. the receiver) to the return value.

If `preservesValue = true` then value flow is propagated. If it is `false` then
only taint flow is propagated.

Any call to `chomp` in the database will be translated, in the dataflow graph,
to a call to this fake definition. 

`input` and `output` define the "from" and "to" locations in the flow summary.
They use a custom string-based syntax which is similar to that used in `path`
column in the Models as Data format. These strings are often referred to as
access paths.

Note: The behaviour documented below is tested in
`dataflow/flow-summaries/behaviour.ql`. Where specific quirks exist, we may
reference a particular test case in this file which demonstrates the quirk.

# Syntax

Access paths consist of zero or more components separated by dots (`.`). The
permitted components differ for input and output paths. The meaning of each
component is defined relative to the implicit context of the component as
defined by the preceding access path. For example,

```
Argument[0].Element[1].ReturnValue
```

refers to the return value of the element at index 1 in the array at argument 0
of the method call.

## `Argument` and `Parameter`

The `Argument` and `Parameter` components refer respectively to an argument to a
call or a parameter of a callable. They contain one or more _specifiers_[^1] which
constrain the range of arguments/parameters that the component refers to. For
example, `Argument[0]` refers to the first argument.

If multiple specifiers are given then the result is a disjunction, meaning that
the component refers to any argument/parameter that satisfies at least one of
the specifiers. For example, `Argument[0, 1]` refers to the first and second
arguments.

### Specifiers

#### `self`
The receiver of the call.

#### `<integer>`
The argument to the method call at the position given by the integer. For
example, `Argument[0]` refers to the first argument to the call.

#### `<integer>..`
An argument to the call at a position greater or equal to the integer. For
example, `Argument[1..]` refers to all arguments except the first one. This
specifier is not available on `Parameter` components.

#### `<string>:`
A keyword argument to the call with the given name. For example,
`Argument[foo:]` refers to the keyword argument `foo:` in the call.

#### `block`
The block argument passed to the call, if any.

#### `any`
Any argument to the call, except `self` or `block` arguments.

#### `any-named`
Any keyword argument to the call.

#### `hash-splat`
The special "hash splat" argument/parameter, which is written as `**args`.
When used in an `Argument` component, this specifier refers to special dataflow
node which is constructed at the call site, containing any elements in a hash
splat argument (`**args`) along with any explicit keyword arguments (`foo:
bar`). The node behaves like a normal dataflow node for a hash, meaning that you
can access specific elements of it using the `Element` component.

For example, the following flow summary states that values flow from any keyword
arguments (including those in a hash splat) to the return value:

```ql
input = "Argument[hash-splat].Element[any]" and
output = "ReturnValue" and
preservesValue = true
```

Assuming this summary is for a global method `foo`, the following test will pass:

```rb
a = source "a"
b = source "b"

h = {a: a}

x = foo(b: b, **h)

sink x # $ hasValueFlow=a hasValueFlow=b
```

If the method returns the hash itself, you will need to use `WithElement` in
order to preserve taint/value in its elements. For example:

```ql
input = "Argument[hash-splat].WithElement[any]" and
output = "ReturnValue" and
preservesValue = true
```
```rb
a = source "a"
x = foo(a: a)
sink x[:a] # $ hasValueFlow=a
```

## `ReturnValue`
`ReturnValue` refers to the return value of the element identified in the
preceding access path. For example, `Argument[0].ReturnValue` refers to the
return value of the first argument. Of course this only makes sense if the first
argument is a callable.

## `Element`
This component refers to elements inside a collection of some sort. Typically
this is an Array or Hash. Elements are considered to have an index, which is an
integer in arrays and a symbol or string in hashes (even though hashes can have
arbitrary objects as keys). Elements can also have an unknown index, which means
we know the element exists in the collection but we don't know where.

Many of the specifiers have an optional suffix `!`. If this suffix is used then
the specifier excludes elements at unknown indices. Otherwise, these are
included by default.

### Specifiers

#### `?`
If used in an input path: an element at an unknown index. If used in an output
path: an element at any known or unkown index. In other words, `?` in an output
path means the same as `any`.

#### `any`
An element at any known or unknown index.

#### `<integer>`, `<integer>!`
An element at the index given by the integer.

#### `<integer>..`, `<integer>..!`
Any element at a known index greater or equal to the integer.

#### `<string>`, `<string>!`
An element at the index given by string. The string should match the result of
`serialize()` on the `ConstantValue` that represents the index. For a string
with contents `foo` this is `"foo"` and for a symbol `:foo` it is `:foo`. The
Ruby values `true`, `false` and `nil` can be written verbatim. See tests 31-33
for examples.

## `Field`
A "field" in the object. In practice this refers to a value stored in an
instance variable in the object. The only valid specifier is `@<string>`, where
`<string>` is the name of the instance variable. Currently we assume that a
setter call such as `x.foo = bar` means there is a field `foo` in `x`, backed by
an instance variable `@foo`.

For example, the access path `Argument[0].Field[@foo]` would refer to the value `"foo"` in

```rb
x = SomeClass.new
x.foo = "foo"
some_call(x)
```

## `WithElement`
This component restricts the set of elements that are included in the preceding
access path to to those at a specific set of indices. The specifiers are the
same as those for `Element`. It is only valid in an input path.

This component has the effect of copying all relevant elements from the input to
the output. For example, in the following summary:

```ql
input = "Argument[0].WithElement[1, 2]" and
output = "ReturnValue"
```

any data in indices 1 and 2 of the first argument will be copied to indices 1
and 2 of the return value. We use this in many Hash summaries that return the
receiver, in order to preserve any data stored in it. For example, the summary
for `Hash#to_h` is

```ql
input = "Argument[self].WithElement[any]" and
output = "ReturnValue" and
preservesValue = true
```

## `WithoutElement`
This component is used to exclude certain elements from the set included in the
preceding access path. It takes the same specifiers as `WithElement` and
`Element`. It is only valid in an input path.

This component has the effect of excluding the relevant elements when copying
from input to output. It is useful for modelling methods that remove elements
from a collection. For example to model a method that removes the first element
from the receiver, we can do so like this:

```ql
input = "Argument[self].WithoutElement[0]" and
output = "Argument[self]"
```

Note that both the input and output refer to the receiver. The effect of this
summary is that use-use flow between the receiver in the method call and a
subsequent use of the same receiver will be blocked:

```ruby
a[0] = source 0
a[1] = source 1

a.remove_first # use-use flow from `a` on this line to `a` below will be blocked.
               # there will still be flow from `[post-update] a` to `a` below.

sink a[0]
sink a[1] # $ hasValueFlow=1
```

It is also important to note that in a summary such as

```ql
input = "Argument[self].WithoutElement[0]" and
output = "ReturnValue"
```

if `Argument[self]` contains data, it will be copied to `ReturnValue`. If you only want to copy data in elements, and not in the container itself, add `WithElement[any]` to the input path:

```ql
input = "Argument[self].WithoutElement[0].WithElement[any]" and
output = "ReturnValue"
```

See tests 53 and 54 for examples of this behaviour.



[^1]: I've chosen this name to avoid overloading the word "argument".
