# Exception-handler name bindings. These are already wired in the new
# CFG provided the try body can raise; `raise` statements are reliably
# treated as exception sources.

try:
    raise ValueError("oops")
except ValueError as e:  # $ cfgdefines=e
    pass

try:
    raise TypeError("oops")
except (TypeError, KeyError) as err:  # $ cfgdefines=err
    pass

# Exception groups (Python 3.11+).
try:
    raise ValueError("oops")
except* ValueError as eg:  # $ cfgdefines=eg
    pass
