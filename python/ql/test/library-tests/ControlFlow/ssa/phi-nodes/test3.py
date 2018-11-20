#Weird formatting is so that all uses and defn are on separate lines
#to assist checking test results.

def phi_in_try():
    try:
        try:
            a_call()
        finally:
            l0 = 0
            another_call()
    except:
        pass
    return l0

