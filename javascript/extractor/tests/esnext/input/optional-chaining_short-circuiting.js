a?.b.c(++x).d;

a?.b[3].c?.(x).d;

(a?.b).c;

(a?.b.c).d;

a?.[b?.c?.d].e?.f;

a?.()[b?.().c?.().d].e?.().f;

if (a?.b) {
    true;
} else {
    false;
}

if (!a?.b) {
    true;
} else {
    false;
}

if (a?.b && c?.d) {
    true;
} else {
    false;
}
