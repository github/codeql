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
/[\u{12340}-\u{12345}]/u;
new RegExp("[\u{12340}-\u{12345}]", "u");
