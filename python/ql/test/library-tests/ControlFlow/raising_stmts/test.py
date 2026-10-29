#All variables that will evaluate before statements start with "AA_"
#so that the test output better reflects the execution order and makes 
#it easier to manually verify.

from _s import *

def f():
    import x
    from a import b
    del AA_s[0]

    AA_q, AA_r = AA_p
    assert AA_c == AA_d

def g():
    try:
        import x
        from a import b
        del AA_s[0]

        AA_q, AA_r = AA_p
        assert AA_c == AA_d
    except:
        pass

def h():
    try:
        a_call()
    except:
        assert AA_c == AA_d
    finally:
        pass

def k():
    try:
        #Safe
        x = y
        c, d = a, b
        #Unsafe
        q, r = p
    except:
        pass


def odasa3686(obj):
    #Test for iterability
        try:
            None in obj
            return True
        except TypeError:
            return False
