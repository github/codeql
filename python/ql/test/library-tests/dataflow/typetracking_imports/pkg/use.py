def test_direct_import():
    from .foo_def import foo # $ tracked
    print(foo) # $ tracked

test_direct_import()


def test_alias_problem():
    from .alias_problem import foo # $ tracked
    print(foo) # $ tracked

test_alias_problem()


def test_alias_problem_fixed():
    from .alias_problem_fixed import foo # $ tracked
    print(foo) # $ tracked

test_alias_problem_fixed()


def test_alias_star():
    from .alias_star import foo # $ tracked
    print(foo) # $ tracked

test_alias_star()


def test_alias_only_direct():
    from .alias_only_direct import foo # $ tracked
    print(foo) # $ tracked

test_alias_only_direct()


def test_problem_absolute_import():
    from pkg.problem_absolute_import import foo # $ tracked
    print(foo) # $ tracked

test_problem_absolute_import()

def test_works_absolute_import():
    from pkg.works_absolute_import import foo # $ tracked
    print(foo) # $ tracked

test_works_absolute_import()
