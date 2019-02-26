

def fail_batch_and_raise(exception):
    if exception is None:
        raise Exception()
    elif exc_info is not None:
        #This failed due to incorrect inference of the class of type(exception) as type.
        raise type(exception), exception, exc_info[2]

#Weird Python2 nonsense.
def raise_tuple(cond):
    if cond:
        # This is OK. Honestly. Thankfully it's fixed in Python 3.
        raise (Exception, "bananas", 17)
    else:
        #This is an error
        raise (17, "bananas", Exception)
