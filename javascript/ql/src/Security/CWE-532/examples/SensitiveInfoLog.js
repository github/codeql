function bad() {
    const password = "Pass@0rd";

    // BAD: user password is written to debug log
    console.debug(password);
}

function good() {
    const password = "Pass@0rd";

    // GOOD: user password is never written to debug log
}