# not importing typing so we don't need to filter by location in Ql tests


def func(
    pos_only: int = -1,
    /,
    normal: int = -2,
    *args: "Tuple[str]",
    keyword_only: int = -3,
    **kwargs: "Dict[str, str]",
):
    print(pos_only, normal, keyword_only)
    print(args)
    print(kwargs)


func(1, 2, keyword_only=3)
func(4, normal=5, keyword_only=6)

func(1, 2, "varargs0", "varargs1", keyword_only=3, kwargs0="0", kwargs1="1")
