/\1(abc)/;      // NOT OK
/(a\1c)/;       // NOT OK
/(ab)\2(c)/;    // NOT OK
/(?:ab)\1(c)/;  // NOT OK
/(abc)\1/;
/<tpl\b[^>]*>((?:(?=([^<]+))\2|<(?!tpl\b[^>]*>))*?)<\/tpl>/;
/\k<ws>(?<ws>\w+)/; // NOT OK
/(?<=\1(.))a/;  // OK
/(?<=(.)\1)a/;  // NOT OK, but not currently flagged
