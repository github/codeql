type Alias[T, *Ts, **P] = tuple[T, *Ts]


match subject:
    case [head, *tail] as whole:
        pass
    case {"key": captured, **rest_mapping}:
        pass


try:
    pass
except* RuntimeError as group_error:
    pass
