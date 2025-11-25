
const jwt = require('jsonwebtoken');

exports.verifyToken = (req, res, next) => {

    let token = req.cookies.accessToken

    if (!token && req.headers['authorization']) {
        const parts = req.headers['authorization'].split(' ')
        if (parts.length === 2 && parts[0] === 'Bearer') {
            token = parts[1]
        }
    }

    if (!token) {
        return res.status(401).json({ message: 'token requerido' });
    }

    jwt.verify(token, process.env.JWT_TOKEN, (err, decoded) => {
        if (err) {
            console.log('❌ token inválido: ', err.message);
            return res.status(401).json({ message: 'token invalido' });
        }

        console.log('✅ Token verificado correctamente.');

        req.user = decoded;
    
        next();
    });
}