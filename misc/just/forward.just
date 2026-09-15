# Common verbs
# See README.md in this directory for an overview.

import "lib.just"

# Verbs are recipe names, so each one needs its own recipe. They all delegate to the
# same forwarder, which decides where the verb is actually implemented.

[no-cd]
[no-exit-message]
[positional-arguments]
@_forward VERB *ARGS:
    {{ py }} "{{ source_dir() }}/forward_command.py" "$@"

alias t := test
alias b := build
alias g := generate
alias gen := generate
alias f := format
alias l := lint

test *ARGS: (_forward "test" ARGS)

build *ARGS: (_forward "build" ARGS)

generate *ARGS: (_forward "generate" ARGS)

lint *ARGS: (_forward "lint" ARGS)

format *ARGS: (_forward "format" ARGS)
