/[foo]/; // $ TODO-SPURIOUS: Alert
/[a-zc]/;
/[\uDC3A\uDC3C]/;
/[??]/; // $ TODO-SPURIOUS: Alert
/[\u003F\u003f]/; // $ TODO-SPURIOUS: Alert
/[\u003F?]/; // $ TODO-SPURIOUS: Alert
/[\x3f\u003f]/; // $ TODO-SPURIOUS: Alert
/[aaa]/; // $ TODO-SPURIOUS: Alert
/[\x0a\x0a]/; // $ TODO-SPURIOUS: Alert
/[\u000a\n]/; // $ TODO-SPURIOUS: Alert
/[\u{ff}]/;
/[\u{12340}-\u{12345}]/u;
new RegExp("[\u{12340}-\u{12345}]", "u");
