// const express = require('express')
// const app = express()
// const port = 3000
//
// app.get('/', (req, res) => res.send('Hello World!!!!!!2122!!!!!!!!'))
// app.get('/error', (req, res) => {
//     console.log("Exiting");
//     process.exit(1)
// })
//
// app.listen(port, () => console.log(`Example app listening on port ${port}!`))


function closeProgam() {
    console.log("Closing")
    process.exit(1)
}

closeProgam();