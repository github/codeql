const express = require('express')
const app = express()
port = 3000

app.get('/test', (req, res) => {
  res.send('test')
})


app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})