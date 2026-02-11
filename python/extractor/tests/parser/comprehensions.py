(a
    for b in c
        if d
        if e
    for f in g
        if h
        if i
)

(a1 for b1 in c1)

(a2 for b2 in c2 if d2)

[k 
    for l in m
        if n
        if o
    for p in q
        if r
        if s
]

[k1 for l1 in m1]

[k2 for l2 in m2 if n2]

{p
    for q in r
        if s
        if t
    for u in v
        if w
        if x
}

{p1 for q1 in r1}

{p2 for q2 in r2 if s2}

    
{k3: v3
    for l3 in m3
        if n3
        if o3
    for p3 in q3
        if r3
        if s3
}

{k4: v4 for l4 in m4}

{k5: v5 for l5 in m5 if n5}

# Special case for generator expressions inside calls
t = tuple(x for y in z)

[(  t,  ) for v in w]

[# comment
    a for b in c # comment
    # comment
] # comment

[# comment
    d for e in f if g # comment
    # comment
] # comment

# Generator expression with comments
(# comment
    alpha # comment
    for beta in gamma # comment
    # comment
)
