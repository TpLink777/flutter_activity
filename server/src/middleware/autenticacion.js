
const jwt = require('jsonwebtoken');

exports.verifyToken = (req, res, next) => {

    let token = null

    if (req.cookies && req.cookies.accessToken) {
        token = req.cookies.accessToken;
        console.log('🍪 Token desde req.cookies');
    }

    if (!token && req.headers.cookie) {
        const cookies = req.headers.cookie.split(';'); // split(';') significa separar la cadena en partes usando ';' como delimitador
        const accessTokenCookie = cookies.find(c => c.trim().startsWith('accessToken='));
        if (accessTokenCookie) {
            token = accessTokenCookie.split('=')[1].split(';')[0];
            console.log('🍪 Token desde headers.cookie');
        }
    }


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