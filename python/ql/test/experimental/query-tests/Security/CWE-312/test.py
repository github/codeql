#Don't import logging; it transitively imports a lot of stuff

def get_bankaccount():
    pass

def log_bankaccount():
    bankaccount = get_bankaccount()
    logging.info("bankaccount '%s'", bankaccount)

def get_salary():
    pass

def log_salary():
    logging.debug("salary=%s", get_salary())

def print_bankaccount():
    print(get_bankaccount())

def write_salary(filename):
    salary = get_salary()
    with open(filename, "w") as file:
        file.write(salary)
