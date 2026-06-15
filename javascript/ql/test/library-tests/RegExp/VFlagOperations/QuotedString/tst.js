/[\q{abc}]/v;
/[\q{abc|cbd|dcb}]/v;
/[\q{\}}]/v;
/[\q{\{}]/v;
/[\q{cc|\}a|cc}]/v;
/[\qq{a|b}]/; // Since v flag is not present matches 'q{a|b}'
