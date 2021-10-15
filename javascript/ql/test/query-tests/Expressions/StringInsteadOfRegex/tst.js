function NOT_OK() {
    // regex-like strings
    "".replace("/foo/i", "");
    "".replace("/^foo/", "");
    "".replace("/foo$/", "");
    "".replace("^foo$", "");
    "".replace("\s", "");
    "".replace("foo\sbar", "");
    "".replace("foo\s", "");
    "".replace("\sbar", "");
    "".replace("foo\[bar", "");
    "".replace("\[", "");
    "".replace("\]", "");
    "".replace("\(", "");
    "".replace("\)", "");
    "".replace("\*", "");
    "".replace("\+", "");
    "".replace("\?", "");
    "".replace("\{", "");
    "".replace("\}", "");
    "".replace("\|", "");
    "".replace("\^", "");
    "".replace("\$", "");
    "".replace("[a-zA-Z123]+", "");
    "".replace("[a-z]+", "");
    "".replace("[a-z]*", "");
    "".replace("[0-9_-]+", "");
    "".replace("[^a-z]+", "");
    "".replace("foo[^a-z]+bar", "");

    // shapes
    f().replace("/foo/i", x);
    var v1 = "/foo/i";
    f().replace(v1, x);
    o.p.q.replace("/foo/i", x);

    // examples in the wild
    "".replace('^\s+|\s+$', '');
    "".replace("[^a-zA-Z0-9 ]+", "");

    // non-replace methods
    "".split("/foo/i");
    "".split("/foo/i", x);
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
