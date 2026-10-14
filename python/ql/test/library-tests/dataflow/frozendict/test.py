def from_keywords():
    frozen = frozendict(tainted=SOURCE, clean=NONSOURCE)
    SINK(frozen["tainted"]) # $ flow="SOURCE, l:-1 -> frozen['tainted']"
    SINK_F(frozen["clean"])


def from_mapping():
    frozen = frozendict({"tainted": SOURCE, "clean": NONSOURCE}, extra=NONSOURCE)
    SINK(frozen["tainted"]) # $ flow="SOURCE, l:-1 -> frozen['tainted']"
    SINK_F(frozen["clean"])
    SINK_F(frozen["extra"])


def from_pairs():
    frozen = frozendict([("key", SOURCE)])
    SINK(frozen["key"]) # $ flow="SOURCE, l:-1 -> frozen['key']"


def from_frozendict():
    original = frozendict(tainted=SOURCE, clean=NONSOURCE)
    frozen = frozendict(original)
    SINK(frozen["tainted"]) # $ flow="SOURCE, l:-2 -> frozen['tainted']"
    SINK_F(frozen["clean"])


def from_unpacked_keywords():
    frozen = frozendict(**{"tainted": SOURCE, "clean": NONSOURCE})
    SINK(frozen["tainted"]) # $ MISSING: flow="SOURCE, l:-1 -> frozen['tainted']"
    SINK_F(frozen["clean"])

    # Keyword unpacking has the same limitation for dict.
    mutable = dict(**{"tainted": SOURCE, "clean": NONSOURCE})
    SINK(mutable["tainted"]) # $ MISSING: flow="SOURCE, l:-1 -> mutable['tainted']"
    SINK_F(mutable["clean"])


def nested_contents():
    frozen = frozendict(nested={"key": SOURCE})
    SINK(frozen["nested"]["key"]) # $ flow="SOURCE, l:-1 -> frozen['nested']['key']"


def qualified_constructor():
    import builtins
    frozen = builtins.frozendict(key=SOURCE)
    SINK(frozen["key"]) # $ flow="SOURCE, l:-1 -> frozen['key']"


def imported_constructor():
    from builtins import frozendict as freeze
    frozen = freeze(key=SOURCE)
    SINK(frozen["key"]) # $ flow="SOURCE, l:-1 -> frozen['key']"


def aliased_constructor():
    freeze = frozendict
    frozen = freeze(key=SOURCE)
    SINK(frozen["key"]) # $ flow="SOURCE, l:-1 -> frozen['key']"


def constructor_callback():
    frozen = next(map(frozendict, [{"key": SOURCE}]))
    SINK(frozen["key"]) # $ flow="SOURCE, l:-1 -> frozen['key']"


def mapping_methods():
    frozen = frozendict(tainted=SOURCE, clean=NONSOURCE)
    SINK(frozen.get("tainted")) # $ flow="SOURCE, l:-1 -> frozen.get(..)"
    SINK_F(frozen.get("clean"))
    SINK_F(frozen.get("missing"))

    copied = frozen.copy()
    SINK(copied["tainted"]) # $ flow="SOURCE, l:-6 -> copied['tainted']"
    SINK_F(copied["clean"])

    values = list(frozen.values())
    SINK(values[0]) # $ flow="SOURCE, l:-10 -> values[0]"

    items = list(frozen.items())
    SINK(items[0][1]) # $ flow="SOURCE, l:-13 -> items[0][1]"
    SINK_F(items[0][0])


def copied_contents():
    original = {"key": SOURCE}
    frozen = frozendict(original)
    original["key"] = NONSOURCE
    SINK(frozen["key"]) # $ flow="SOURCE, l:-3 -> frozen['key']"
    SINK_F(original["key"])


def shadowed_constructor():
    def frozendict(**kwargs):
        return {"key": NONSOURCE}

    frozen = frozendict(key=SOURCE)
    SINK_F(frozen["key"])
