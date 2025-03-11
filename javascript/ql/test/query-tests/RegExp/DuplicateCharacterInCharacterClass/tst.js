/[foo]/; // $ Alert
/[a-zc]/;
/[\uDC3A\uDC3C]/;
/[??]/; // $ Alert
/[\u003F\u003f]/; // $ Alert
/[\u003F?]/; // $ Alert
/[\x3f\u003f]/; // $ Alert
/[aaa]/; // $ Alert
/[\x0a\x0a]/; // $ Alert
/[\u000a\n]/; // $ Alert
/[\u{ff}]/;
new RegExp("[\u{12340}-\u{12345}]", "u");
const regex = /\b(?:https?:\/\/|mailto:|www\.)(?:[\S--[\p{P}<>]]|\/|[\S--[\[\]]]+[\S--[\p{P}<>]])+|\b[\S--[@\p{Ps}\p{Pe}<>]]+@([\S--[\p{P}<>]]+(?:\.[\S--[\p{P}<>]]+)+)/gmv;
