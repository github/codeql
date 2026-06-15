# Building Concrete Parse Trees using the Python grammar

This grammar is mostly reusing existing code:

- `lib2to3` is a part of the `2to3` utility (included in the CPython
  distribution) aimed at automatically converting Python 2 code to equivalent
  Python 3 code. Because it needs to be idempotent when applied to Python 3
  code, this grammar must be capable of parsing both Python 2 and 3 (with
  certain restrictions).
- `blib2to3` is part of the `black` formatter for Python. It adds a few
  extensions on top of `lib2to3`.
- Finally, we extend this grammar even further, in order to support things like
  f-strings even when the extractor is run using Python 2. (In this respect,
  `blib2to3` "cheats" by requiring Python 3 if you want to parse Python 3 code.
  We do not have this luxury.)

The grammar of Python is described in `Grammar.txt` in the style of an EBNF:

- Rules have the form `nonterminal_name: production` (where traditionally, one
  would use `::=` instead of `:`)
- Productions can contain
    - Literal strings, enclosed in single quotes.
    - Alternation, indicated by an infix `|`.
    - Repetition, indicated by a postfixed `*` for "zero or more" and `+` for
      "one or more".
    - Optional parts, indicated by these being surrounded by square brackets.
    - Parentheseses to indicate grouping, and to allow productions to span several lines.

>Note: You may wonder: How is `Grammar.txt` parsed? The answer to this is that
>it is used to parse itself. In particular, it uses the same tokenizer as that
>for Python, and hence every symbol appearing in the grammar must be a valid
>Python token. This is why rules use `:` instead of `::=`. This also explains
>why parentheses must be used when a production spans multiple lines, as the
>presence of parentheses affects the tokenization.

The concrete parse tree built based on these rules has a simple form: Each node
has a `name` attribute, equal to that of the corresponding nonterminal, and a
`children` attribute, which contains a list of all of the children of the node.
These come directly from the production on the right hand side of the rule for
the given nonterminal. Thus, something like 

```
testlist: test (',' test)* [',']
```

will result in a node with name `testlist`, and its attribute `children` will be
a list where the first element is a `test` node, the second (if any) is a node
for `','`, etc. Note in particular that _every_ part of the production is
included in the children, even parts that are just static tokens.

The leaves of the concrete parse tree (corresponding to the terminals of the
grammar) will have an associated `value` attribute. This contains the underlying
string for this token (in particular, for a `NAME` token, its value will be the
underlying identifier).

## From Concrete to Abstract

To turn the concrete parse tree into an asbstract parse tree, we _walk_ the tree
using the visitor pattern. Thus, for every nonterminal (e.g. `testlist`) we have
a method (in this case `visit_testlist`) that takes care of visiting nodes of
this type in the concrete parse tree. In doing so, we build up the abstract
parse tree, eliding any nodes that are not relevant in terms of the abstract
syntax.

>TO DO: 
>- Why we parse everything four times (`async` et al.)

