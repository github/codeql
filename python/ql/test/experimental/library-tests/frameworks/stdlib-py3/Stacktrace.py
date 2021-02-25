import sys, traceback

try:
    1/0
except:
    exc_type, exc_value, exc_traceback = sys.exc_info() #$ errorInfoSource

    tb = traceback.extract_tb(exc_traceback) #$ errorInfoSource
    stack = traceback.extract_stack() #$ errorInfoSource
    print(traceback.format_exc(1, tb)) #$ errorInfoSource
    print(traceback.format_exception(exc_type, exc_value, exc_traceback)) #$ errorInfoSource
    print(traceback.format_exception_only(None, exc_value)) #$ errorInfoSource
    print(traceback.format_list(stack)) #$ errorInfoSource
    print(traceback.format_stack()) #$ errorInfoSource
    print(traceback.format_tb(exc_traceback)) #$ errorInfoSource
