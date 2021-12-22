const express = require('express');

const app = express();

app.use((req, res, next) => {
    res.locals.taintedInMiddleware = req.query.taintA;
    next();
});

app.get('/fooA', (req, res) => {
    res.render('main', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('main.ejs', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('subfolder', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('subfolder/index', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('subfolder/index.ejs', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('subfolder/other', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('subfolder/other.ejs', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });

    res.render('subfolder/subsub', {
        sinkA: req.query.sinkA,
        sinkB: req.query.sinkB,
    });
});
