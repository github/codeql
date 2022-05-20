class X {
    m() {
        m("default"); // OK
    }

    resty(...x) {
        m("default"); // NOT OK
    }
}
