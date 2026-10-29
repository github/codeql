
#Mistakenly mixed list and string
def greeting():
    if is_global():
        greet = [ "Hello", "World" ]
    else:
        greet = "Hello"
    for word in greet:
        print(word)

#Only use list
def fixed_greeting():
    if is_global():
        greet = [ "Hello", "World" ]
    else:
        greet = [ "Hello" ]
    for word in greet:
        print(word)
