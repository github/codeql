# See https://github.com/Semmle/ql/issues/3113
def some_decorator(func):
    print("this could be tricky for our analysis")
    return func

class Foo(object):

    @classmethod
    def no_problem(cls):
        check(cls) # analysis says 'cls' can only point-to Class Foo

    @some_decorator
    @classmethod
    def problem_through_instance(cls):
        # Problem is that our analysis says that 'cls' can point to EITHER the
        # Class Foo (correct) or an instance of Foo (wrong)
        check(cls)

    @some_decorator
    @classmethod
    def problem_through_class(cls):
        check(cls) # same as above

    @classmethod
    @some_decorator
    def also_problem(cls):
        check(cls) # same as above

# We need to call the methods before our analysis works
f1 = Foo()
f1.no_problem()
f1.problem_through_instance()
f1.also_problem()

Foo.problem_through_class()
