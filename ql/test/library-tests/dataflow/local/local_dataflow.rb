def foo(a)
  b = a
  c = (p a; b)
  d = c = a
  d = (c = a)
  e = (a += b)
end

array = [1,2,3]
y = for x in array
do
  p x
end

for x in array do
  break 10
end

for x in array do
  if x > 1 then break end
end

while true
 break 5
end
