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


def func2(
    pos_req,
    pos_w_default: "foo" = None,
    pos_w_default2=None,
    *,
    keyword_req,
    keyword_w_default: "foo" = None,
    keyword_also_req,
):
    print("func2")
    print(
        pos_req,
        pos_w_default,
        pos_w_default2,
        keyword_req,
        keyword_w_default,
        keyword_also_req,
    )


func2(1, keyword_req=2, keyword_also_req=3)
