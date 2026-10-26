import { source1 as whoKnowsWhetherThisIsTainted, notTaintedTrustMe, x } from './a';
import deflt from './a';

let sink1 = whoKnowsWhetherThisIsTainted;
let sink2 = notTaintedTrustMe;
let sink3 = x;
let sink4 = deflt;
