const express = require('express')
var bodyParser = require('body-parser');
const app = express()
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

//Dependent of Templating engine
var jade = require('pug');
const port = 5061

function getHTML(input) {
    var template = `
doctype
html
head
    title= 'Hello world'
body
    form(action='/' method='post')
        label(for='name') Name:
            input#name.form-control(type='text', placeholder='' name='name')
        button.btn.btn-primary(type='submit') Submit
    p Hello `+ input
    var fn = jade.compile(template);
    var html = fn();
    console.log(html);
    return html;
}

app.post('/', (request, response) => {
    var input = request.param('name', "")
    var html = getHTML(input)
    response.send(html);
})

app.listen(port, () => { console.log(`server is listening on ${port}`) })
