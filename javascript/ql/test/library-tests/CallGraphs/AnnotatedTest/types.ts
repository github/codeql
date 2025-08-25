namespace NS {
  export class C {
    /** name:NS.C.m */
    m() { }
  }

  export class D extends C { }
}

function t1(c: NS.C, d: NS.D) {
  /** calls:NS.C.m */
  c.m();

  /** calls:NS.C.m */
  d.m();
}

async function t2(cp: Promise<NS.C>) {
  const c = await cp;
  /** calls:NS.C.m */
  c.m();

  cp.then(c2 => {
    /** calls:NS.C.m */
    c2.m();
  })
}
