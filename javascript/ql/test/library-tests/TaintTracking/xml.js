(function () {
    var Parser = require("node-expat").Parser
    var parser = new Parser();

    parser.write(source());

    parser.on("text", text => {
        sink(text); // NOT OK
    });
})();