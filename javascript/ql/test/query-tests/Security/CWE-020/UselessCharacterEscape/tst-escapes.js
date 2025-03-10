// no backslashes
RegExp("abcdefghijklmnopqrstuvxyz");
RegExp("ABCDEFGHIJKLMNOPQRSTUVXYZ");
RegExp("`1234567890-=");
RegExp("~!@#$%^&*()_+");
RegExp("[]'\\,./");
RegExp("{}\"|<>?");
RegExp(" ");

// backslashes
RegExp("\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\\u\v\\x\y\z"); // $ Alert
RegExp("\A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\X\Y\Z"); // $ Alert
RegExp("\`\1\2\3\4\5\6\7\8\9\0\-\="); // $ Alert
RegExp("\~\!\@\#\$\%\^\&\*\(\)\_\+"); // $ Alert
RegExp("\[\]\'\\,\.\/"); // $ Alert
RegExp("\{\}\\\"\|\<\>\?"); // $ Alert
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
RegExp("\.") // $ Alert
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
RegExp("[\.]"); // $ Alert
RegExp("a[b\.c]d"); // $ Alert
RegExp("\b");
RegExp(`\b`);
RegExp(`\k\\k\d\\d`) // $ Alert
RegExp(`\k\\k${foo}\d\\d`) // $ Alert

// effective escapes
RegExp("\]") // $ Alert
RegExp("\\]")
RegExp("\\\]"); // effectively escaped after all
RegExp("x\\\]"); // effectively escaped after all
RegExp("\\\\]")
RegExp("\\\\\]") // $ Alert
RegExp("\\\\\\]")
RegExp("\\\\\\\]") // effectively escaped after all
RegExp("\\\\\\\\]")
RegExp("\\\\\\\\\]") // $ Alert
