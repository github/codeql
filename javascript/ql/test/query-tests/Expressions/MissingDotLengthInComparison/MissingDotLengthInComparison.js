function total(bad) {
    var sum = 0
    for (var i = 0; i < bad; ++i) { // NOT OK
        sum += bad[i]
    }
    return sum
}

function total_good(good) {
    var sum = 0
    for (var i = 0; i < good.length; ++i) { // OK
        sum += good[i]
    }
    return sum
}

var fruits = ["banana", "pineapple"]
function mix() {
    var drink = []
    for (var i = 0; i < fruits; ++i) { // NOT OK
        drink.push(fruits[i])
    }
}

function mix_good() {
    var drink = []
    for (var i = 0; i < fruits.length; ++i) { // OK
        drink.push(fruits[i])
    }
}

function overloaded(mode, foo, bar) {
    if (mode == "floo") {
        return foo < bar; // OK
    } else if (mode == "blar") {
        return foo[bar];
    } else {
        return [foo, bar];
    }
}

function overloaded_no_else(mode, foo, bar) {
    if (mode == "floo") {
        return foo < bar; // OK
    }
    if (mode == "blar") {
        return foo[bar];
    }
}

function reassigned(index, object) {
    var tmp = object.getMaximum()
    if (index < tmp) { // OK
        tmp = object.getArray()
        return tmp[index]
    }
}
