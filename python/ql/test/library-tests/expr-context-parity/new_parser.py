import package
import package.module as imported_module
from package import member
from package import other as imported_member


type Alias[T, *Ts, **P] = tuple[T, *Ts]


annotated: object = value
plain = annotated
first = second = plain
(tuple_target, [list_target, *rest]) = values
(walrus_target := plain)

for (loop_item, *loop_rest) in iterable:
    pass

items = [item for item in iterable]

with manager as (resource, *resources):
    pass

try:
    pass
except Exception as error:
    pass

match subject:
    case [head, *tail] as whole:
        pass
    case {"key": captured, **rest_mapping}:
        pass

try:
    pass
except* RuntimeError as group_error:
    pass

del plain
del object_value.attribute
del sequence[index]
del tuple_target, list_target


def function(positional, default=value, *args, keyword_only, **kwargs):
    positional += 1
    object_value.attribute = positional
    sequence[index] = positional
    return positional, default, args, keyword_only, kwargs


lambda_function = (
    lambda positional, default=value, *args, keyword_only, **kwargs:
        (positional, default, args, keyword_only, kwargs)
)
