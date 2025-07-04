import "lib.just"

# copy&paste necessary for each command until proper forwarding of multiple args is implemented
# see https://github.com/casey/just/issues/1988

_forward := tsx + ' "' + source_dir() + '/forward-command.ts"'


[no-cd, positional-arguments, no-exit-message]
@test *ARGS=".":
    {{ _forward }} test "$@"


[no-cd, positional-arguments, no-exit-message]
@build *ARGS=".":
    {{ _forward }} build "$@"

[no-cd, positional-arguments, no-exit-message]
@generate *ARGS=".":
    {{ _forward }} generate "$@"

[no-cd, positional-arguments, no-exit-message]
@lint *ARGS=".":
    {{ _forward }} lint "$@"

[no-cd, positional-arguments, no-exit-message]
@format *ARGS=".":
    {{ _forward }} format "$@"
