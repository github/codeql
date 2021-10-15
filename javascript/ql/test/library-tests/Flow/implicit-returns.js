import 'dummy';

function endWithLoop() {
    var i = 0;
    while (i < 10) {
        if (Math.random() * 10 < i) {
            return true;
        }
        ++i;
    }
    // Can fall over end
}

function useLoop() {
    let x = endWithLoop(); // can be true or undefined
}

function endWithShortIf() {
    if (something() < 10) {
        return true;
    }
}

function useShortIf() {
    let x = endWithShortIf(); // true or undefined
}
