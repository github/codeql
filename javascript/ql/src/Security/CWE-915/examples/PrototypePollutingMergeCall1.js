app.get('/news', (req, res) => {
  let prefs = lodash.merge({}, JSON.parse(req.query.prefs));
})
