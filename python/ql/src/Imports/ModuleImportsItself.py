import ModuleImportsItself

def factorial(n):
    if n <= 0:
        return 1
    return n * ModuleImportsItself.factorial(n - 1)