(async function(){
    f(endpoint);
    f({p: endpoint});
    f({p: {q: endpoint}});
    o.m(endpoint);
    o.m({p: endpoint});
    o.m({p: {q: endpoint}});
    new F(endpoint);
    o.m().m().m(endpoint);
    f()(endpoint);
    o[x].m(endpoint);
    o.m[x].p.m(endpoint);
    (await p)(endpoint);
});