function isSafe(key) {
    return key !== "__proto__" && key !== "constructor" && key !== "prototype";
}

function assignToPath(target, path, value) {
    let keys = path.split('.');
    for (let i = 0; i < keys.length; ++i) {
        let key = keys[i]; // $ Source
        if (i < keys.length - 1) {
            if (!target[key]) {
                target[key] = {};
            }
            target = target[key];
        } else {
            target[key] = value; // $ Alert
        }
    }
}

function assignToPathSafe(target, path, value) {
    let keys = path.split('.');
    for (let i = 0; i < keys.length; ++i) {
        let key = keys[i];
        if (!isSafe(key)) return;
        if (i < keys.length - 1) {
            if (!target[key]) {
                target[key] = {};
            }
            target = target[key];
        } else {
            target[key] = value;
        }
    }
}


function assignToPathAfterLoop(target, path, value) {
    let keys = path.split('.');
    let i;
    for (i = 0; i < keys.length - 1; ++i) {
        let key = keys[i]; // $ Source
        target = target[key] = target[key] || {};
    }
    target[keys[i]] = value; // $ Alert
}

function splitHelper(path, sep) {
    let parts = typeof path === 'string' ? path.split(sep || '.') : path;
    let result = [];
    result.push(...parts);
    return result;
}

function assignToPathWithHelper(target, path, value, sep) {
    let keys = splitHelper(path, sep)
    let i;
    for (i = 0; i < keys.length - 1; ++i) {
        let key = keys[i]; // $ Source
        target = target[key] = target[key] || {};
    }
    target[keys[i]] = value; // $ Alert
}

function spltOnRegexp(target, path, value) {
    let keys = path.split(/\./);
    let i;
    for (i = 0; i < keys.length - 1; ++i) {
        let key = keys[i]; // $ Source
        target = target[key] = target[key] || {};
    }
    target[keys[i]] = value; // $ Alert
}