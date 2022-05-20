def unnecessary_delete():
    x = get_some_object()
    do_calculation(x)
    del x                       # This del statement is unnecessary
