const express = require('express')
var pug = require('pug');
const app = express()

app.post('/', (req, res) => {
    var input = req.query.username;
    var template = `
doctype
html
head
    title= 'Hello world'
body
    form(action='/' method='post')
        input#name.form-control(type='text)
        button.btn.btn-primary(type='submit') Submit
    p Hello #{username}`
    var fn = pug.compile(template);
    var html = fn({username: input});
    res.send(html);
})
