const express = require('express');

let app = express();

app.get('/ejs', (req, res) => {
    res.render('ejs_sinks', {
        escapedHtml: req.query.escapedHtml,
        rawHtml: req.query.rawHtml,
        rawHtmlSafeValue: 'safe',
        object: {
            rawHtmlProp: req.query.rawHtmlProp
        },
        dataInStringLiteral: req.query.dataInStringLiteral,
        dataInStringLiteralRaw: req.query.dataInStringLiteralRaw,
        dataInGeneratedCode: req.query.dataInGeneratedCode,
        dataInGeneratedCodeRaw: req.query.dataInGeneratedCodeRaw,
        backslashSink1: req.query.backslashSink1,
        backslashSink2: req.query.backslashSink2,
        dataInEventHandlerString: req.query.dataInEventHandlerString,
        dataInEventHandlerStringRaw: req.query.dataInEventHandlerStringRaw,
    });
});

app.get('/hbs', (req, res) => {
    res.render('hbs_sinks', {
        escapedHtml: req.query.escapedHtml,
        rawHtml: req.query.rawHtml,
        rawHtmlSafeValue: 'safe',
        object: {
            rawHtmlProp: req.query.rawHtmlProp
        },
        dataInStringLiteral: req.query.dataInStringLiteral,
        dataInStringLiteralRaw: req.query.dataInStringLiteralRaw,
        dataInGeneratedCode: req.query.dataInGeneratedCode,
        dataInGeneratedCodeRaw: req.query.dataInGeneratedCodeRaw,
        backslashSink1: req.query.backslashSink1,
        backslashSink2: req.query.backslashSink2,
        dataInEventHandlerString: req.query.dataInEventHandlerString,
        dataInEventHandlerStringRaw: req.query.dataInEventHandlerStringRaw,
    });
});
