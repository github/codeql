a = 3
b = a

def f(x):
  y = x + 2 # would expect flow to here from x
  return y - 2 # would expect flow to here from y

c = f(a)
