import sys, traceback

try:
    1/0
except:
    exc_type, exc_value, exc_traceback = sys.exc_info() #$ exceptionInfo

    tb = traceback.extract_tb(exc_traceback) #$ exceptionInfo
    stack = traceback.extract_stack() #$ exceptionInfo
    print(traceback.format_exc(1, tb)) #$ exceptionInfo
    print(traceback.format_exception(exc_type, exc_value, exc_traceback)) #$ exceptionInfo
    print(traceback.format_exception_only(None, exc_value)) #$ exceptionInfo
    print(traceback.format_list(stack)) #$ exceptionInfo
    print(traceback.format_stack()) #$ exceptionInfo
    print(traceback.format_tb(exc_traceback)) #$ exceptionInfo
