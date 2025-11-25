const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.generateToken = (user) => {
    return jwt.sign({
        id: user.id,
        nombre: user.nombre
    },
        process.env.JWT_TOKEN,
        {
            expiresIn: '24h'
        });
}