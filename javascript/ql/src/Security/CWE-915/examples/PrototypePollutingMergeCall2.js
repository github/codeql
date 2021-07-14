app.get('/news', (req, res) => {
  let config = lodash.merge({}, {
    prefs: req.query.prefs
  });
})
