
def call_main_program_implicit_handle_base_exception():
    try:
        #application.main calls sys.exit() when done.
        application.main()
    except Exception as ex:
        log(ex)
    except:
        pass

def call_main_program_explicit_handle_base_exception():
    try:
        #application.main calls sys.exit() when done.
        application.main()
    except Exception as ex:
        log(ex)
    except BaseException:
        pass

def call_main_program_fixed():
    try:
        #application.main calls sys.exit() when done.
        application.main()
    except Exception as ex:
        log(ex)
    except SystemExit:
        pass
