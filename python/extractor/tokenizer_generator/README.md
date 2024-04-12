# The Python tokenizer

This file describes the syntax and operational semantics of the state machine
that underlies our tokenizer.

## The state machine syntax

The state machine is described in a declarative fashion in the
`state_transition.txt` file. This file contains a sequence of declarations, as
described in the following subsections.

Additionally, lines may contain comments indicated using the `#` character, as
in Python itself.

In the remainder of the document, "identifier" means any sequence of characters
starting with a letter (`a-z` or `A-Z`) and followed by a sequence of letters,
digits, and/or underscores.

### Start declarations
This has the form `start: ` followed by the name of a table. It is used to
indicate what table is used as the starting point for the tokenization.

There should be exactly one of these declarations in the file.

### Alias declarations
These have the form
```
identifier = id_or_char or id_or_char or ...
```
where `id_or_char` is either a single character surrounded by single quotes
(e.g. `'a'`) or an identifier defined in another alias declaration.

Thus, aliases define _sets_ of characters: single-quoted characters representing
singleton sets, and `or` being set union.
>Note: A few character classes are predefined: 
> - `ERROR` representing the error state of the state machine,
> - `IDENTIFIER` representing characters that can appear at the start of
>   a Unicode identifier, and
> - `IDENTIFIER_CONTINUE` representing characters that can appear
>   within a Unicode identifier.

### Table declarations
These have the form 

```
table header {
    state_transition
    state_transition
    ...
}
```
where `header` is either an identifier or an identifier followed by another
identifier surrounded by parentheses. The latter implements a form of
"inheritance" between tables, and is explained in a later section.

The format of `state_transition`s is described in the next subsection.

### State transitions
Each state transition has the following form:
```
set_of_before_states -> after_state for set_of_characters optional_actions
```
Here, `set_of_before_states` is either a single identifier or a list of identifiers
with `or`s interspersed (mimicking the way sets of characters are specified) and
`after_state` is an identifier. These identifiers do not have to be declared
separately &mdash; they are implicitly declared when used.
>Note: A special state `0` (in the table indicated with the `start: `
>declaration represents the starting state for the entire tokenization.

The `set_of_characters` can either be
- the identifier corresponding to an alias,
- a single character (e.g. `'a'`),
- a list of sets of characters with `or`s interspersed, or
- an asterisk `*` representing _all_ characters that do not already have a
  transition defined for the set of "before" states.

After the state transition is an optional list of actions, described next.

### Actions
Actions are specified using the keyword `do`. After this keyword, one or more
actions may be specified, each terminated with `;`, e.g.
```
foo -> bar for 'a' do action1; action2;
```
As the actions are very operational in nature, they will be described when we go
into the operational semantics of the state machine.

## Informal operational semantics
>Note: What follows is not based on a reading of the source code, but just
>experience with working with modifying the state machine. There may be
>significant inaccuracies.

At a high level, the purpose of the tokenizer is to partition the given input
into a sequence of strings representing tokens. The decision of where to put the
boundaries between these strings is done on a character-by-character basis. To
mark the start of a token, the action `mark` is used. Note that the mark is
placed _before_ the character that caused the action to be executed. That is, in
the following transition rule
```
foo -> bar for 'a' do mark;
```
the mark is placed _before_ the `a`.

Once the end of a token has been reached, the `emit` action is used. This
creates a token from the part of the input spanning from the most recent `mark`
up to (and including) the character that caused the transition to which the
`emit` action is attached.

As an example, consider the following state machine that splits a sequence of
zeroes and ones into tokens consisting of (maximal) runs of each character:

```
start: default
table default {

    # This is essentially just an unconditional state transition.
    0 -> zero_or_one for * do pushback;

    zero_or_one -> zeros for '0' do mark;
    zero_or_one -> ones for '1' do mark;

    zeros -> zeros for '0'
    zeros -> zero_or_one for * do pushback; emit(ZEROS);

    ones -> zero_or_one for * do pushback; emit(ONES);
    ones -> ones for '1'
}
```
The `pushback` action has the effect of "pushing back" the current character.
(In reality, all this does is move the pointer to the current character one step
back. It is thus not a problem to have several pushbacks in a row.)

> Note: The order in which the transition rules for a state is specified does
> not matter. Even if the `*` state is listed first, as with `ones` above, it
> does not take precedence over other more specific character sets.

After tokenizing a string with the above grammar, the result will be a sequence
of `ZEROS` and `ONES` tokens. Each of these will have three pieces of data
associated with it: the starting point (line and column), the end point (also
line and column), and the characters that make up the token. Note that `emit`
accepts a second argument (which must be a string) as well. For example, the
transition for code when reaching a newline is:
```
feed = '\r' or '\n'
...
    code -> whitespace_line for feed do emit(NEWLINE, "\n"); newline;
```
This has the effect of normalizing end of line characters to be `\n`.

>Note: The replacement text may have a different length than the distance to the
>most recent `span`. This may not be desirable.

The above snippet introduces another action: `newline`. This has the effect of
resetting the column counter to zero and incrementing the line counter.

>Note: There are some peculiarities about newlines, and the tokenizer will get
>confused if they are not handled through the `newline` action.

The last two actions have to do with maintaining a stack of parsing tables. At
all points, the behavior of the tokenizer is governed by the table that is on
top of the stack. The `push` action pushes the specified table (given as an
argument) on top of this stack. Naturally, the `pop` action does the opposite,
discarding the top element.

This leaves the final point of interest: what decides which transitions are
"active" at a given point?

The way this functions is essentially like method dispatch in Python (though
thankfully there is no multiple inheritance). Thus, given the current state and
the current character, we first look in the table on top of the stack. If this
table does not have a transition for the given state and character, we next look
at the table it inherits from, and so forth.
