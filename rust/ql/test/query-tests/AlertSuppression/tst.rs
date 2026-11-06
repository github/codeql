fn main() {
    let mut x = 42;
    x = x + 1; // lgtm
    x = x + 1; // lgtm[rust/redundant-operation]
    x = x + 1; // lgtm[rust/redundant-operation, rust/unused-value]
    x = x + 1; // lgtm[@tag:nullness]
    x = x + 1; // lgtm[@tag:nullness,rust/redundant-operation]
    x = x + 1; // lgtm[@expires:2017-06-11]
    x = x + 1; // lgtm[rust/redundant-operation] because I know better than lgtm
    x = x + 1; // lgtm: blah blah
    x = x + 1; // lgtm blah blah #falsepositive
    x = x + 1; //lgtm  [rust/redundant-operation]
    x = x + 1; /* lgtm */
    x = x + 1; // lgtm[]
    x = x + 1; // lgtmfoo
    x = x + 1; //lgtm
    x = x + 1; //	lgtm
    x = x + 1; // lgtm	[rust/redundant-operation]
    x = x + 1; // foolgtm[rust/redundant-operation]
    x = x + 1; // foolgtm
    x = x + 1; // foo; lgtm
    x = x + 1; // foo; lgtm[rust/redundant-operation]
    x = x + 1; // foo lgtm
    x = x + 1; // foo lgtm[rust/redundant-operation]
    x = x + 1; // foo lgtm bar
    x = x + 1; // foo lgtm[rust/redundant-operation] bar
    x = x + 1; // LGTM!
    x = x + 1; // LGTM[rust/redundant-operation]
    x = x + 1; // lgtm[rust/redundant-operation] and lgtm[rust/unused-value]
    x = x + 1; // lgtm[rust/redundant-operation]; lgtm
    x = x + 1; /* lgtm[] */
    x = x + 1; /* lgtm[rust/redundant-operation] */
    x = x + 1; /* lgtm
               */
    x = x + 1; /* lgtm

               */
    x = x + 1; /* lgtm[@tag:nullness,rust/redundant-operation] */
    x = x + 1; /* lgtm[@tag:nullness] */
    // codeql[rust/redundant-operation]
    x = x + 1;
    // CODEQL[rust/redundant-operation]
    x = x + 1;
    // codeql[rust/redundant-operation] -- because I know better than codeql
    x = x + 1;
    /* codeql[rust/redundant-operation] */
    x = x + 1;
    /* codeql[rust/redundant-operation]
    */
    x = x + 1;
    x = x + 1; // codeql[rust/redundant-operation]
    println!("{}", x);
}
