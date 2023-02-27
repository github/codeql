def test_direct_import():
    from .func_def import func
    func() # $ pt,tt="pkg/func_def.py:func"

test_direct_import() # $ pt,tt=test_direct_import


def test_alias_problem():
    from .alias_problem import func
    func() # $ pt,tt="pkg/func_def.py:func"

test_alias_problem() # $ pt,tt=test_alias_problem


def test_alias_problem_fixed():
    from .alias_problem_fixed import func
    func() # $ pt,tt="pkg/func_def.py:func"

test_alias_problem_fixed() # $ pt,tt=test_alias_problem_fixed


def test_alias_star():
    from .alias_star import func
    func() # $ pt,tt="pkg/func_def.py:func"

test_alias_star() # $ pt,tt=test_alias_star


def test_alias_only_direct():
    from .alias_only_direct import func
    func() # $ pt,tt="pkg/func_def.py:func"

test_alias_only_direct() # $ pt,tt=test_alias_only_direct
