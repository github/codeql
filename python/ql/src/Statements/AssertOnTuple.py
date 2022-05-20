assert xxx and yyy   # Alternative 1a. Check both expressions are true

assert xxx, yyy      # Alternative 1b. Check 'xxx' is true, 'yyy' is the failure message.

tuple = (xxx, yyy)   # Alternative 2. Check both elements of the tuple match expectations.
assert tuple[0]==xxx
assert tuple[1]==yyy
