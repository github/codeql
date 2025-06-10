/[foo]/; // $ Alert
/[a-zc]/;
/[\uDC3A\uDC3C]/;
/[??]/; // $ Alert
/[\u003F\u003f]/; // $ Alert
/[\u003F?]/; // $ Alert -- \u003F evaluates to ?, which is the same as ? in the character class
/[\x3f\u003f]/; // $ Alert
/[aaa]/; // $ Alert
/[\x0a\x0a]/; // $ Alert
/[\u000a\n]/; // $ Alert -- \u000a evaluates to \n, which is the same as \n in the character class
/[\u{ff}]/;
/[\u{12340}-\u{12345}]/u;
new RegExp("[\u{12340}-\u{12345}]", "u");
const regex = /\b(?:https?:\/\/|mailto:|www\.)(?:[\S--[\p{P}<>]]|\/|[\S--[\[\]]]+[\S--[\p{P}<>]])+|\b[\S--[@\p{Ps}\p{Pe}<>]]+@([\S--[\p{P}<>]]+(?:\.[\S--[\p{P}<>]]+)+)/gmv;
/[a|b|c]/; // $ Alert -- Reapted | character in character class, which has no special meaning in this context
/[:alnum:]/; // $ Alert -- JavaScript does not support POSIX character classes like `[:alnum:]` in regular expressions, thus characters in the class are treated as literals
/[(^style|^staticStyle)]/; // $ Alert
/[.x.]/i; // $ Alert -- Repeated . character in character class
/^[يفمأمسند]/i; // $ Alert -- م duplicate
/[\u{1F600}-\u{1F64F}]/u;
/[\p{Letter}&&\p{ASCII}]/v; // && is an intersection operator while /v flag is present
/[\p{Letter}&&\p{ASCII}]/; // $ Alert -- without /v flag, && is not a valid operator and treated as member of character class thus duplicate
/[\p{Decimal_Number}&&[0-9A-F]]/v;
/[\p{Letter}--[aeiouAEIOU]]/v;
/[\p{Letter}\p{Decimal_Number}]/v; // Union operation between two character classes only with /v flag
/[\p{Letter}\p{Decimal_Number}]/; // $ Alert -- without /v flag, this is not a valid operation and treated as member of character class thus duplicate
/[\[\]]/;
/[/[/]]/; // $ Alert
/[^^abc]/; // First `^` is a negation operator, second treated as literal `^` is a member of character class
/[^^^abc]/; // $ Alert -- Second and third `^` are treated as literals thus duplicates
/[^**]/; // $ Alert
/[-a-z]/; // Matches `-` and range `a-z` no duplicate
/^[:|\|]/ // $ Alert -- `|` is treated as a literal character in the character class, thus duplicate even with escape character
