const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => res.send('Hello World!!!!!!222!!!!!!!!'))
// app.get('/error', (req, res) => {
//     process.exit(1)
// })

app.listen(port, () => console.log(`Example app listening on port ${port}!`))