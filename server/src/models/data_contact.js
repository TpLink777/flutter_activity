const  sequenlize = require('../config/db')
const { DataTypes } = require('sequelize')

const DataContact = sequenlize.define('data_contact', {
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    apellido: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    correo: {
        type: DataTypes.STRING(150),
        allowNull: false,
        unique: true
    },
    image_url: {
        type: DataTypes.STRING(500),
        allowNull: false,
    },
    password: {
        type: DataTypes.STRING(255),
        allowNull: false,
    }
}, {
    tableName: 'data_contact_user',
    timestamps: true,
})

module.exports = DataContact