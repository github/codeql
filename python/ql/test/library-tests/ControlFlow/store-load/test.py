# Store/load/delete/parameter classification on the new-CFG facade.
#
# Each annotated location carries the (sorted, deduplicated) set of
# kinds the CFG facade reports there. Comparing against the legacy
# 'semmle.python.Flow' classification is done by the comparison query
# 'StoreLoadParity.ql' — annotations here are only the positive
# assertions for the new facade.
#
# Tags:
#   load=<id>       -- isLoad() fires on the Name
#   store=<id>      -- isStore() fires
#   delete=<id>     -- isDelete() fires
#   param=<id>      -- isParameter() fires
#   augload=<id>    -- isAugLoad() fires (the LHS of x += ... when read)
#   augstore=<id>   -- isAugStore() fires (the LHS of x += ... when written)


# --- plain load / store / delete ---

x = 1  # $ store=x
y = x + 1  # $ store=y load=x
print(y)  # $ load=print load=y
del x  # $ delete=x


# --- function definitions (parameters) ---

def f(a, b=2, *args, c, **kwargs):  # $ store=f param=a param=b param=args param=c param=kwargs
    return a + b + c  # $ load=a load=b load=c


# --- augmented assignment splits one Name into load + store halves ---

def aug():  # $ store=aug
    n = 0  # $ store=n
    n += 1  # $ augload=n augstore=n
    return n  # $ load=n


# --- subscript / attribute stores ---

class C:  # $ store=C
    pass


def stores(obj, container, idx):  # $ store=stores param=obj param=container param=idx
    obj.attr = 1  # $ load=obj
    container[idx] = 2  # $ load=container load=idx
    return obj  # $ load=obj


# --- tuple unpacking ---

def unpack(pair):  # $ store=unpack param=pair
    a, b = pair  # $ store=a store=b load=pair
    return a + b  # $ load=a load=b
