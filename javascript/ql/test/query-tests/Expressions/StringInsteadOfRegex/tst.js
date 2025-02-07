function NOT_OK() {
    // regex-like strings
    "".replace("/foo/i", ""); // $ TODO-SPURIOUS: Alert
    "".replace("/^foo/", ""); // $ TODO-SPURIOUS: Alert
    "".replace("/foo$/", ""); // $ TODO-SPURIOUS: Alert
    "".replace("^foo$", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\s", ""); // $ TODO-SPURIOUS: Alert
    "".replace("foo\sbar", ""); // $ TODO-SPURIOUS: Alert
    "".replace("foo\s", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\sbar", ""); // $ TODO-SPURIOUS: Alert
    "".replace("foo\[bar", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\[", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\]", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\(", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\)", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\*", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\+", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\?", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\{", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\}", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\|", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\^", ""); // $ TODO-SPURIOUS: Alert
    "".replace("\$", ""); // $ TODO-SPURIOUS: Alert
    "".replace("[a-zA-Z123]+", ""); // $ TODO-SPURIOUS: Alert
    "".replace("[a-z]+", ""); // $ TODO-SPURIOUS: Alert
    "".replace("[a-z]*", ""); // $ TODO-SPURIOUS: Alert
    "".replace("[0-9_-]+", ""); // $ TODO-SPURIOUS: Alert
    "".replace("[^a-z]+", ""); // $ TODO-SPURIOUS: Alert
    "".replace("foo[^a-z]+bar", ""); // $ TODO-SPURIOUS: Alert

    // shapes
    f().replace("/foo/i", x); // $ TODO-SPURIOUS: Alert
    var v1 = "/foo/i";
    f().replace(v1, x); // $ TODO-SPURIOUS: Alert
    o.p.q.replace("/foo/i", x); // $ TODO-SPURIOUS: Alert

    // examples in the wild
    "".replace('^\s+|\s+$', ''); // $ TODO-SPURIOUS: Alert
    "".replace("[^a-zA-Z0-9 ]+", ""); // $ TODO-SPURIOUS: Alert

    // non-replace methods
    "".split("/foo/i"); // $ TODO-SPURIOUS: Alert
    "".split("/foo/i", x); // $ TODO-SPURIOUS: Alert
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
