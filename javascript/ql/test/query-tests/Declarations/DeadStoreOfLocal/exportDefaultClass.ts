var C1 = global.C1; // OK
var C2 = global.C2; // OK

class C extends C1 {}
export default class extends C2 {}
