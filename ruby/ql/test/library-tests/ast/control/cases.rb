# Define some variables used below
a = 0
b = 0
c = 0
d = 0

# A case expr with a value and an else branch
case a
when b
    100
when c, d
    200
else
    300
end

# A case expr without a value or else branch
case
when a > b  then 10
when a == b then 20
when a < b  then 30
end