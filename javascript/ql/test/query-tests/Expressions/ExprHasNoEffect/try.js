function try1(x) {
    try {
        x.ordinaryProperty; // OK - try/catch indicates intent to throw exception
    } catch (e) {
        return false;
    }
    return true;
}

function try2(x) {
    try {
        x.ordinaryProperty; // OK - try/catch indicates intent to throw exception
        return x;
    } catch (e) {
        return false;
    }
}

function try3(x) {
    try {
        x.ordinaryProperty()
        x.ordinaryProperty // $ Alert
        return x;
    } catch (e) {
        return false;
    }
}
