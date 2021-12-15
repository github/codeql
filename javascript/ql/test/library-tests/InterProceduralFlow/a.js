let source1 = "tainted";
let source2 = "also tainted";

export { source1, source2 as notTaintedTrustMe };
export let x = "not tainted";
export default x;

x = source1;
