# name:no_annotated_call
def no_annotated_call():
    pass

def callable_not_annotated():
    pass

no_annotated_call()
# calls:callable_not_annotated
callable_not_annotated()

# name:non_unique
def non_unique():
    pass

# name:non_unique
def too_much_copy_paste():
    pass

# calls:non_unique
non_unique()
