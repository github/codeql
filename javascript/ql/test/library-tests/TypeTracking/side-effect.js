function assignSource(obj) {
    let tracked = function() {}; // name: SE1
    obj.f = tracked;
}

function useAssignSource() {
    let obj = {};
    assignSource(obj);
    let f = obj.f; // track: SE1
}

