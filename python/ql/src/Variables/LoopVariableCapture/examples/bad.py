# BAD: The loop variable `i` is captured.
tasks = []
for i in range(5):
    tasks.append(lambda: print(i))

# This will print `4,4,4,4,4`, rather than `0,1,2,3,4` as likely intended.
for t in tasks:
    t() 