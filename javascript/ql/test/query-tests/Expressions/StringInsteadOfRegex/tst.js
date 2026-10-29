function NOT_OK() {
    // regex-like strings
    "".replace("/foo/i", ""); // $ Alert
    "".replace("/^foo/", ""); // $ Alert
    "".replace("/foo$/", ""); // $ Alert
    "".replace("^foo$", ""); // $ Alert
    "".replace("\s", ""); // $ Alert
    "".replace("foo\sbar", ""); // $ Alert
    "".replace("foo\s", ""); // $ Alert
    "".replace("\sbar", ""); // $ Alert
    "".replace("foo\[bar", ""); // $ Alert
    "".replace("\[", ""); // $ Alert
    "".replace("\]", ""); // $ Alert
    "".replace("\(", ""); // $ Alert
    "".replace("\)", ""); // $ Alert
    "".replace("\*", ""); // $ Alert
    "".replace("\+", ""); // $ Alert
    "".replace("\?", ""); // $ Alert
    "".replace("\{", ""); // $ Alert
    "".replace("\}", ""); // $ Alert
    "".replace("\|", ""); // $ Alert
    "".replace("\^", ""); // $ Alert
    "".replace("\$", ""); // $ Alert
    "".replace("[a-zA-Z123]+", ""); // $ Alert
    "".replace("[a-z]+", ""); // $ Alert
    "".replace("[a-z]*", ""); // $ Alert
    "".replace("[0-9_-]+", ""); // $ Alert
    "".replace("[^a-z]+", ""); // $ Alert
    "".replace("foo[^a-z]+bar", ""); // $ Alert

    // shapes
    f().replace("/foo/i", x); // $ Alert
    var v1 = "/foo/i";
    f().replace(v1, x); // $ Alert
    o.p.q.replace("/foo/i", x); // $ Alert

    // examples in the wild
    "".replace('^\s+|\s+$', ''); // $ Alert
    "".replace("[^a-zA-Z0-9 ]+", ""); // $ Alert

    // non-replace methods
    "".split("/foo/i"); // $ Alert
    "".split("/foo/i", x); // $ Alert
}

function OK() {
    // negatives
    f.replace("/foo/i");
    f.replace({}, "");
    f.replace("/foo/i", "", "");

    f.replace(/foo/i, "");

    var v2 = "/foo/" + "i";
    f().replace(v2, x); // only handing string literals

    f.replace("\\s", "");
    f.replace("\\d", "");
    f.replace("\\(", "");
    f.replace("\\[", "");
}
