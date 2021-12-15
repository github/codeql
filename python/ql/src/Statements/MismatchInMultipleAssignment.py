# Fibonacci series 1:
# the sum of two elements defines the next

a, b = 0, 1, 1  # Assignment fails: accidentally put three values on right
while b < 10:
     print b
     a, b = b, a+b

# Fibonacci series 2:
# the sum of two elements defines the next
a, b = 0, 1   # Assignment succeeds: two variables on left and two values on right
while b < 10:
     print b
     a, b = b, a+b
