# Simple summary
tainted = identity("taint")
sink(tainted)

# Lambda summary
tainted_lambda = apply_lambda(lambda x: x + 1, tainted)
sink(tainted_lambda)

# Collection summaries
tainted_list = reversed([tainted])
sink(tainted_list[0])

# Complex summaries
def add_colon(x):
    return x + ":"

tainted_mapped = map(add_colon, [tainted])
sink(tainted_mapped[0])

def explicit_identity(x):
    return x

tainted_mapped_explicit = map(explicit_identity, [tainted])
sink(tainted_mapped_explicit[0])

tainted_mapped_summary = map(identity, [tainted])
sink(tainted_mapped_summary[0])
