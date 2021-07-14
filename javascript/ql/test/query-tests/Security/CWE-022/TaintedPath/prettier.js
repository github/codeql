const express = require('express');
const prettier = require("prettier");

const app = express();
app.get('/some/path', function (req, res) {
    const { p } = req.params;
    prettier.resolveConfig(p).then((options) => { // NOT OK
        const formatted = prettier.format("foo", options);
    });

    prettier.resolveConfig("foo", {config: p}).then((options) => { // NOT OK
        const formatted = prettier.format("bar", options);
    });
});
