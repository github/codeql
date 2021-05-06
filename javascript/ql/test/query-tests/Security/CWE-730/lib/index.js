module.exports.searchForName = function (name) {
    return new RegExp('(^| )' + name + '( |$)'); // NOT OK
}