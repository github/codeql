class RegexRule:
    @staticmethod
    def compile(pattern):
        return pattern


class GlobRule:
    @staticmethod
    def compile(pattern):
        return pattern


def compile_rules(rule_type, patterns):
    return [rule_type.compile(pattern) for pattern in patterns]


compile_rules(RegexRule, ["x"])
compile_rules(GlobRule, ["*"])


def decorate(func):
    def wrapper():
        return func()

    return wrapper


@decorate
def first():
    return 1


@decorate
def second():
    return 2


first()
second()
