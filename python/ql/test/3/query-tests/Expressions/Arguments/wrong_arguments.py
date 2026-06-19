#Make sure that we handle keyword-only arguments correctly


def f(a, *varargs, kw1, kw2="has-default"):
    pass

#OK
f(1, 2, 3, kw1=1)
f(1, 2, kw1=1, kw2=2)

#Not OK
f(1, 2, 3, kw1=1, kw3=3)
f(1, 2, 3, kw3=3)


#ODASA-5897
def analyze_member_access(msg, *, original, override, chk: 'default' = None):
    pass

def ok():
    return analyze_member_access(msg, original=original, chk=chk)

def bad():
    return analyze_member_access(msg, original, chk=chk)
