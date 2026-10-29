/\1(abc)/;      // $ Alert
/(a\1c)/;       // $ Alert
/(ab)\2(c)/;    // $ Alert
/(?:ab)\1(c)/;  // $ Alert
/(abc)\1/;
/<tpl\b[^>]*>((?:(?=([^<]+))\2|<(?!tpl\b[^>]*>))*?)<\/tpl>/;
/\k<ws>(?<ws>\w+)/; // $ Alert
/(?<=\1(.))a/;
/(?<=(.)\1)a/;  // $ MISSING: Alert
