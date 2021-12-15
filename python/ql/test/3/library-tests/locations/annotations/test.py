#PEP 484 style annotations.

def func(callee_type: CallableType,
         formal_to_actual: List[List[int]],
         strict: bool = True) -> List[Type]:
    pass


def func(self,
         name: str,
         args: List[str],
         *,
         cwd: str = None,
         env: Dict[str, str] = None) -> None:
    pass

def specials(self, *varargs: vanno, **kwargs: kwanno):
    pass

