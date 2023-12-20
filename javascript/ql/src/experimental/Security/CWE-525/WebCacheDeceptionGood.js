const express = require('express')
const app = express()
port = 3000

app.get('/test', (req, res) => {
  res.send('Company: Trendyol, Birth Date: 1997, Country: Turkey, Phone: 5554443322')
})


app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})