/[foo]/;
/[a-zc]/;
/[\uDC3A\uDC3C]/; // False positive caused by the extractor converting both unpaired surrogates to \uFFFD
/[??]/;
/[\u003F\u003f]/;
/[\u003F?]/;
/[\x3f\u003f]/;
/[aaa]/;
/[\x0a\x0a]/;
/[\u000a\n]/;
/[\u{ff}]/;
/[\u{12340}-\u{12345}]/u; // OK
new RegExp("[\u{12340}-\u{12345}]", "u"); // OK
