// (the lines of this file are not annotated with alert expectations)

// no backslashes
RegExp("abcdefghijklmnopqrstuvxyz");
RegExp("ABCDEFGHIJKLMNOPQRSTUVXYZ");
RegExp("`1234567890-=");
RegExp("~!@#$%^&*()_+");
RegExp("[]'\\,./");
RegExp("{}\"|<>?");
RegExp(" ");

// backslashes
RegExp("\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\\u\v\\x\y\z");
RegExp("\A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\X\Y\Z");
RegExp("\`\1\2\3\4\5\6\7\8\9\0\-\=");
RegExp("\~\!\@\#\$\%\^\&\*\(\)\_\+");
RegExp("\[\]\'\\,\.\/");
RegExp("\{\}\\\"\|\<\>\?");
RegExp("\ ");
/\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\\x\y\z"/;
/\A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\X\Y\Z/;
/\`\1\2\3\4\5\6\7\8\9\0\-\=/;
/\~\!\@\#\$\%\^\&\*\(\)\_\+/;
/\[\]\'\\,\.\//;
/\{\}\"\|\<\>\?/;
/\ /;

// many backslashes
RegExp("\a");
RegExp("\\a");
RegExp("\\\a");
RegExp("\\\\a");
RegExp("\\\\\a");
RegExp("\\\\\\a");
RegExp("\\\\\\\a");
RegExp("\\\\\\\\a");
RegExp("\\\\\\\\\a");
RegExp("\\\\\\\\\\a");

// string vs regexp
RegExp("\.")
"\.";

// other
/\/\\\/\\\\\//;
RegExp("\uaaaa\uAAAA\uFFFF\u1000");
RegExp("\xaaaa\xAAAA\xFFFF\x1000");
RegExp("'\'\\'");
RegExp("\"\\\"");
RegExp('"\"\\"'),
RegExp('\'\\\''),
RegExp("^\\\\Q\\\\E$");
RegExp("/\\*");
RegExp("/\
");
RegExp("[\.]");
RegExp("a[b\.c]d");
RegExp("\b");
RegExp(`\b`);
RegExp(`\k\\k\d\\d`)
RegExp(`\k\\k${foo}\d\\d`)

// effective escapes
RegExp("\]")
RegExp("\\]")
RegExp("\\\]"); // effectively escaped after all
RegExp("x\\\]"); // effectively escaped after all
RegExp("\\\\]")
RegExp("\\\\\]")
RegExp("\\\\\\]")
RegExp("\\\\\\\]") // effectively escaped after all
RegExp("\\\\\\\\]")
RegExp("\\\\\\\\\]")
