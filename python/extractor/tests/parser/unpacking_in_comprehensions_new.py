# PEP 798: Unpacking in comprehensions

# Star unpacking in list comprehension
[*x for x in y]

# Star unpacking in set comprehension
{*x for x in y}

# Double-star unpacking in dict comprehension
{**d for d in dicts}

# Star unpacking in generator expression
(*x for x in y)

# With conditions
[*x for x in y if x]

# Multiple for clauses
[*x for y in z for x in y]
