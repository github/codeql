express().get('/news', (req, res) => {
    let topic = req.query.topic;
    res.send(`<h1>${topic}</h1>`);
});
