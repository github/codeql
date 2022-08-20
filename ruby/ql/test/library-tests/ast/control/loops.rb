# Define some variables used below.
foo = 0
sum = 0
x = 0
y = 0
z = 0

# For loop with a single variable as the iteration argument
for n in 1..10
    sum += n
    foo = n
end

# For loop with a single variable and a trailing comma as the iteration
# argument
for n in 1..10
    sum += n
    foo -= n
end

# For loop with a tuple pattern as the iteration argument
for key, value in {foo: 0, bar: 1}
  sum += value
  foo *= value
end

# Same, but with parentheses around the pattern
for (key, value) in {foo: 0, bar: 1}
  sum += value
  foo /= value
  break
end

# While loop
while x < y
  x += 1
  z += 1
  next
end

# While loop with `do` keyword
while x < y do
  x += 1
  z += 2
end

# While-modified expression
x += 1 while y >= x

# Until loop
until x == y
  x += 1
  z -= 1
end

# Until loop with `do` keyword
until x > y do
  x += 1
  z -= 4
end

# Until-modified expression
x -= 1 until x == 0

# While loop with empty `do` block
while x < y do
end
