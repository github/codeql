# Define some variables used below
a = 0
b = 0
c = 0
d = 0
e = 0
f = 0

# If expr with no else
if a > b then
    c
end

# If expr with single else
if a == b
    c
else
    d
end

# If expr with multiple nested elsif branches
if a == 0 then
    c
elsif a == 1 then
    d
elsif a == 2 then
    e
else
    f
end

# If expr with elsif and then no else
if a == 0
    b
elsif a == 1
    c
end

# Unless expr with no else
unless a > b then
    c
end

# Unless expr with else
unless a == b
    c
else
    d
end

# If-modified expr
a = b if c > d

# Unless-modified expr
a = b unless c < d

# Ternary if expr
a = b > c ? d + 1 : e - 2

# If expr with empty else (treated as no else)
if a > b then
    c
else
end

# If expr with empty then (treated as no then)
if a > b then
else
    c
end