/[[abc]&&[bcd]]/v; // Valid use of intersection operator, matches b or c
/abc&&bcd/v; //Valid regex, but no intersection operation: Matches the literal string "abc&&bcd"
/[abc]&&[bcd]/v; // Valid regex, but incorrect intersection operation: 
                 // - Matches a single character from [abc]
                 // - Then the literal "&&"
                 // - Then a single character from [bcd]
/[[abc]&&[bcd]&&[c]]/v; // Valid use of intersection operator, matches c
