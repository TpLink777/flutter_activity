const express = require('express')
const morgan = require('morgan')
const cors = require('cors')
require('dotenv').config()


const app = express()
const PORT = process.env.PORT || 3000 

app.use(morgan('dev'))
app.use(express.json())
app.use(cors())


//importacion de rutas...
const data_contact = require('./routes/data_contact.routes.js') 

app.use('/api/activity', data_contact)


app.use('/', (req, res) => {
    res.send(`Servidoir iniciando correctamente en el puerto ${PORT}`)
})


app.listen(PORT, () => {
    console.log(`Servidoir corriendo en:  http://localhost:${PORT}`)
})
