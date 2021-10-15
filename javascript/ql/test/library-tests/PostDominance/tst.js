function defCalledFunctionExample() {
    call1();
    call2();

    if (someCond) {
        maybeCall1();
    } else {
        maybeCall2();
    }

    call3();

    try {
        call4();
    } catch(e) {
        maybeCall3();
    } finally {
        call5();
    }

    call6();

    return;

    noCall();
}
