app.get('/news', (req, res) => {
  let prefs = lodash.merge({}, {
    topic: req.query.topic
  });
})
