

def incorrect_except_order(val):
    try:
        val.attr
    except Exception:
        print ("Exception")
    except AttributeError:
        print ("AttributeError")
        
