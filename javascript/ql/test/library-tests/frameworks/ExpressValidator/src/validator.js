
const express = require('express')
const { query, body } = require('express-validator');

const app = express();

app.get('/secure/1', query('search').escape(), (req, res) => {
    return res.send(`<h1>Searching: ${req.query.search}!</h1>`);        // Secure: Escaped
})
app.get('/secure/2', query('type').isInt(), (req, res) => {
    return res.send(`<h1>Type: ${req.query.type}!</h1>`);               // Secure: Only Integers allowed
})
app.get('/secure/3', query('email').isEmail(), (req, res) => {
    return res.send(`<h1>Email: ${req.query.email}!</h1>`);             // Secure: Only email allowed
})
app.get('/secure/4', query('type').isIn(["this", "or", "that"]), (req, res) => {
    return res.send(`<h1>Type: ${req.query.type}!</h1>`);               // Secure: Only in list allowed
})
app.get('/secure/5', query('search').notEmpty().isString().escape(), (req, res) => {
    return res.send(`<h1>Searching: ${req.query.search}!</h1>`);        // Secure: Chain of validations with escape
})

app.get(
    '/multichains/1',
    [query('search').escape(), query('type').isInt(), query('email').isEmail()],
    (req, res) => {
        return res.send(`<h1>Searching: ${req.query.search} - ${req.query.type}</h1><h2>User: ${req.query.email}</h2>`);        // Secure: Chain of validations with escape
    }
)

app.get('/insecure/1', (req, res) => {
    return res.send(`<h1>Searching: ${req.query.search}!</h1>`);        // Insecure: No escaping
})
app.get('/insecure/2', query('search').escape(), (req, res) => {
    return res.send(`<h1>Searching: ${req.query.name}!</h1>`);          // Insecure: No escaping
})
app.get('/insecure/3', body('name').escape(), (req, res) => {
    return res.send(`<h1>Searching: ${req.query.name}!</h1>`);          // Insecure: No escaping
})


app.listen(8000, () => {
    console.log(`Example app listening on port 8000`)
})
