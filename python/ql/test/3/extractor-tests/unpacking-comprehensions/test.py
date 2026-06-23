# PEP 798: Unpacking in comprehensions

flat_list = [*x for x in nested]

flat_set = {*x for x in nested}

merged = {**d for d in dicts}

gen = (*x for x in nested)

# Force the new parser (the old parser cannot handle lazy imports)
lazy import _pep798_parser_hint
