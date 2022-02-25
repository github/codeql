# FP involving global variables modified in a different scope

i = 0
def update_i():
    global i
    i = i + 1

update_i()
if i > 0:
    print("i is greater than 0") # FP: This is reachable
