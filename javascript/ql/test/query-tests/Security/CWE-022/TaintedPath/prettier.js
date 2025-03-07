const express = require('express');
const prettier = require("prettier");

const app = express();
app.get('/some/path', function (req, res) {
    const { p } = req.params; // $ Source
    prettier.resolveConfig(p).then((options) => { // $ Alert
        const formatted = prettier.format("foo", options);
    });

    prettier.resolveConfig("foo", {config: p}).then((options) => { // $ Alert
        const formatted = prettier.format("bar", options);
    });
});
