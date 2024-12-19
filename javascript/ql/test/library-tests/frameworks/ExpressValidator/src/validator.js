
const express = require('express')
const { query, body } = require('express-validator');

const app = express();

app.get('/secure/1', query('search').escape(), (req, res) => {      // $ middleware=parameter::search
    return res.send(`<h1>Searching: ${req.query.search}!</h1>`);    // $ secure=req.query.search
})
app.get('/secure/2', query('type').isInt(), (req, res) => {         // $ middleware=parameter::type
    return res.send(`<h1>Type: ${req.query.type}!</h1>`);           // $ secure=req.query.type
})
app.get('/secure/3', query('email').isEmail(), (req, res) => {      // $ middleware=parameter::email
    return res.send(`<h1>Email: ${req.query.email}!</h1>`);         // $ secure=req.query.email
})
app.get('/secure/4', query('type').isIn(["this", "or", "that"]), (req, res) => {    // $ middleware=parameter::type
    return res.send(`<h1>Type: ${req.query.type}!</h1>`);                           // $ secure=req.query.type
})
app.get('/secure/5', query('search').notEmpty().isString().escape(), (req, res) => {    // $ middleware=parameter::search
    return res.send(`<h1>Searching: ${req.query.search}!</h1>`);                        // $ secure=req.query.search
})

app.get(
    '/multichains/1',
    [
        query('search').escape(),       // $ middleware=parameter::search
        query('type').isInt(),          // $ middleware=parameter::type
        query('email').isEmail()        // $ middleware=parameter::email
    ],
    (req, res) => {
        return res.send(
            `<h1>Searching: ${req.query.search} - ${req.query.type}</h1><h2>User: ${req.query.email}</h2>`  // $ secure=req.query.search secure=req.query.type secure=req.query.email
        );        
    }
)

app.get('/insecure/1', (req, res) => {
    return res.send(`<h1>Searching: ${req.query.search}!</h1>`);
})
app.get('/insecure/2', query('search').escape(), (req, res) => {        // $ middleware=parameter::search
    return res.send(`<h1>Searching: ${req.query.name}!</h1>`);
})
app.get('/insecure/3', body('name').escape(), (req, res) => {           // $ middleware=body::name
    return res.send(`<h1>Searching: ${req.query.name}!</h1>`);
})


app.listen(8000, () => {
    console.log(`Example app listening on port 8000`)
})
