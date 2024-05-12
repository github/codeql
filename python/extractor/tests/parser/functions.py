def a(b): pass
def c(*d): pass

def foo(a, b, c=d, e:f, g:h=i, *j) -> t:
    x
    y

def foo(l):
    pass

def bar(*k):
    x1
    y1

def bar(*k, l, m:n, o:p=q, r=s, **u):
    x1
    y1

def klef(*): pass

def main(): pass

@dec1(a,b)
@dec2(c,d)
def func(e,f,g):
    h
    i


lambda: a

lambda b: c

lambda d, *e: f

lambda *g, h: i

lambda j=k: l

lambda *m: n

lambda **o: p

lambda *p, q=r: s

def typed_dictionary_splat(**kw : KEYWORD):
    pass
def typed_list_splat(*args : ARGS):
    pass

@False or True
def decorated(): pass

def all_separators(pos_only, /, pos_or_keyword, *, keyword_only): pass

@decorator #comment
def decorated_with_comment():
    pass
