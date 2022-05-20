#Strings
"a" < "b"
"aa" < "a"

#Integers
-4 < 0
0 > -3
0 < 1
1 == 5

#Too large
984523954611637034671 < 5857262868067092615796134571

#Nonsense
1 < "a"
len(unknown()) = "foo"

#Imprecise
len(unknown()) == 5
len(unknown()) < 7
len(unknown()) == len(unknown())
len(unknown()) < len(unknown())

0+0 == 0
0+1 == 0

#All ops
2 > 3
2 == 3
2 != 3
2 < 3
2 >= 3
2 <= 3

#Booleans
1 < True
2 > False
True == False
True is False
True is True
False is not True
