# Code snippets extracted from the motivational document:
# https://www.python.org/dev/peps/pep-0635/

match x:
    case host, port:
        mode = "http"
    case host, port, mode:
        pass
    # Etc.

match node:
    case BinOp("+", a, BinOp("*", b, c)):
        # Handle a + b*c

match json_pet:
    case {"type": "cat", "name": name, "pattern": pattern}:
        return Cat(name, pattern)
    case {"type": "dog", "name": name, "breed": breed}:
        return Dog(name, breed)
    case _:
        raise ValueError("Not a suitable pet")

def sort(seq):
    match seq:
        case [] | [_]:
            return seq
        case [x, y] if x <= y:
            return seq
        case [x, y]:
            return [y, x]
        case [x, y, z] if x <= y <= z:
            return seq
        case [x, y, z] if x >= y >= z:
            return [z, y, x]
        case [p, *rest]:
            a = sort([x for x in rest if x <= p])
            b = sort([x for x in rest if p < x])
            return a + [p] + b

def simplify_expr(tokens):
    match tokens:
        case [('('|'[') as l, *expr, (')'|']') as r] if (l+r) in ('()', '[]'):
            return simplify_expr(expr)
        case [0, ('+'|'-') as op, right]:
            return UnaryOp(op, right)
        case [(int() | float() as left) | Num(left), '+', (int() | float() as right) | Num(right)]:
            return Num(left + right)
        case [(int() | float()) as value]:
            return Num(value)

def simplify(expr):
    match expr:
        case ('/', 0, 0):
            return expr
        case ('*'|'/', 0, _):
            return 0
        case ('+'|'-', x, 0) | ('+', 0, x) | ('*', 1, x) | ('*'|'/', x, 1):
            return x
    return expr

def simplify(expr):
    match expr:
        case ('+', 0, x):
            return x
        case ('+' | '-', x, 0):
            return x
        case ('and', True, x):
            return x
        case ('and', False, x):
            return False
        case ('or', False, x):
            return x
        case ('or', True, x):
            return True
        case ('not', ('not', x)):
            return x
    return expr

def average(*args):
    match args:
        case [x, y]:           # captures the two elements of a sequence
            return (x + y) / 2
        case [x]:              # captures the only element of a sequence
            return x
        case []:
            return 0
        case a:                # captures the entire sequence
            return sum(a) / len(a)

def is_closed(sequence):
    match sequence:
        case [_]:               # any sequence with a single element
            return True
        case [start, *_, end]:  # a sequence with at least two elements
            return start == end
        case _:                 # anything
            return False

def handle_reply(reply):
    match reply:
        case (HttpStatus.OK, MimeType.TEXT, body):
            process_text(body)
        case (HttpStatus.OK, MimeType.APPL_ZIP, body):
            text = deflate(body)
            process_text(text)
        case (HttpStatus.MOVED_PERMANENTLY, new_URI):
            resend_request(new_URI)
        case (HttpStatus.NOT_FOUND):
            raise ResourceNotFound()

def change_red_to_blue(json_obj):
    match json_obj:
        case { 'color': ('red' | '#FF0000') }:
            json_obj['color'] = 'blue'
        case { 'children': children }:
            for child in children:
                change_red_to_blue(child)
