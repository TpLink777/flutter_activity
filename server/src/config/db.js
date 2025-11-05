const { Sequelize } = require('sequelize')
require('dotenv').config()


const sequelize = new Sequelize(
    process.env.NAME_DB,
    process.env.USER,
    process.env.PASSWORD,
    {
        host: process.env.HOST,
        dialect: 'mysql',
        port: process.env.PORT_DB
    }
)

module.exports = sequelize
