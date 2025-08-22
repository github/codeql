# This test file is inspired by
# `csharp/ql/test/library-tests/dataflow/local/UseUseExplosion.cs`
# but with `n=3` kept small, since we do have the explosion.

cond = ...

# global variables are slightly special,
# so we go into a function scope
def scope():
    x = 0

    if(cond > 3):
      if(cond > 2):
        if(cond > 1):
           pass
        else:
          x = 1
      else:
        x = 2
    else:
      x = 3

    if(cond > 3):
      if(cond > 2):
        if(cond > 1):
           pass
        else:
          use(x)
      else:
        use(x)
    else:
      use(x)

    def use(v):
        # this could just be `pass` but we do not want it optimized away.
        y = v+2