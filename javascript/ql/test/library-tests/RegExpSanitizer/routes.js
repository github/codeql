const cp = require("child_process");
const app = require("express")();

app.get("/a", (req, res) => {
    const dir = req.query.dir;
    if (/^[\w.-]+$/m.test(dir)) {
        cp.exec("ls " + dir); // $ command-injection
    }
    res.send("ok");
});

app.get("/b", (req, res) => {
    const dir = req.query.dir;
    if (/^[\w.-]+$/.test(dir)) {
        cp.exec("ls " + dir);
    }
    res.send("ok");
});

app.get("/c", (req, res) => {
    cp.exec("ls " + req.query.dir); // $ command-injection
    res.send("ok");
});

app.get("/d", (req, res) => {
    const name = req.query.name;
    if (/^\w+$/m.test(name)) {
        res.send("<p>Hello " + name + "</p>"); // $ reflected-xss
    } else {
        res.send("bad name");
    }
});

app.get("/e", (req, res) => {
    res.send("<p>Hello " + req.query.name + "</p>"); // $ reflected-xss
});
