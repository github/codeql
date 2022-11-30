import { bar, F, p } from 'lib1';
import * as o from 'lib2';
const f = require('lib3');

(async function () {
    f(endpoint, 12);
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
    import("foo").bar.baz(endpoint);
    function foo() {
        bar(endpoint);
    }
    (f() ? f : o.m)(endpoint);
});

function f({ endpoint }) {}

const g = async () => undefined;

const o = { m: () => undefined }

const url = f();

const x = f() + "<a target=\"_blank\" href=\"" + endpoint + "\"></a>";

const y = "foo"+ endpoint + "bar";
