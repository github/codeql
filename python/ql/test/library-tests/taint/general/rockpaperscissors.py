

def rock(arg):
    "SCISSORS are vulnerable"

def paper(arg):
    "ROCK is vulnerable"

def scissors(arg):
    "PAPER is vulnerable"

def test1():
    rock(SCISSORS)

def test2():
    paper(ROCK)

def test3():
    x = ROCK
    y = x.prev() #scissors
    scissors(y)

def test4():
    x = ROCK
    y = x.prev().prev() # paper
    scissors(y)

def test5():
    x = SCISSORS
    y = x.prev() # paper
    paper(x)
    paper(y)
