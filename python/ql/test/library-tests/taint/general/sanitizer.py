
#Sanitizer functions
def isEscapedSql(arg): pass

def isValidCommand(arg): pass


def sql_inject1():
    x = user_input()
    if isEscapedSql(x):
        sql_query(x)  # Safe
    else:
        sql_query(x)  # DANGEROUS

def command_inject1():
    x = user_input()
    if isValidCommand(x):
        os_command(x)  # Safe
    else:
        os_command(x)  # DANGEROUS


def sql_inject2():
    x = user_input()
    if notASanitizer(x):
        sql_query(x)  # DANGEROUS
    else:
        sql_query(x)  # DANGEROUS

def command_inject2():
    x = user_input()
    if notASanitizer(x):
        os_command(x)  # DANGEROUS
    else:
        os_command(x)  # DANGEROUS

