const express = require('express')
const router = express.Router()
const upload = require('../middleware/cloud')
const dataContactController = require('../controllers/data_contact.controller')
const token = require('../middleware/autenticacion')

const { body, param, query } = require('express-validator')


// ------------------------
// GET: Ver información
// ------------------------
router.get(
    '/findInformationData',
    token.verifyToken,
    dataContactController.ViewContacts
)


// ------------------------
// POST: Crear contacto
// ------------------------
router.post(
    '/add-data-contact',
    upload.single('image'),
    [
        body('nombre')
            .notEmpty().withMessage('El nombre no puede estar vacío')
            .isString().withMessage('El nombre debe ser un texto'),

        body('apellido')
            .notEmpty().withMessage('El apellido no puede estar vacío')
            .isString().withMessage('El apellido debe ser un texto'),

        body('correo')
            .notEmpty().withMessage('El correo no puede estar vacío')
            .isEmail().withMessage('El correo ingresado no es válido'),

        body('password')
            .notEmpty().withMessage('La contraseña no puede estar vacía')
            .isString().withMessage('La contraseña debe ser un texto')
            .isLength({ min: 8 }).withMessage('La contraseña debe tener al menos 8 caracteres')
            .matches(/(?=.*\d)(?=.*[A-Z])(?=.*[a-z])/)
            .withMessage('La contraseña debe contener mayúsculas, minúsculas y números')
    ],
    dataContactController.CreatePossibleContact
)


// ------------------------
// PUT: Actualizar contacto
// ------------------------
router.put(
    '/updated-information/:id',
    token.verifyToken,
    upload.single('image'),
    [
        param('id')
            .notEmpty().withMessage('El ID no puede estar sin valor')
            .isInt().withMessage('El ID debe ser un número entero positivo'),

        body('nombre')
            .optional()
            .isString().withMessage('El nombre debe ser un texto'),

        body('apellido')
            .optional()
            .isString().withMessage('El apellido debe ser un texto'),

        body('correo')
            .optional()
            .isEmail().withMessage('El correo ingresado no es válido'),
    ],
    dataContactController.UpdateContact
)


// ------------------------
// DELETE: Eliminar contacto
// ------------------------
router.delete(
    '/delete-information/:id',
    token.verifyToken,
    [
        param('id')
            .notEmpty().withMessage('El ID no puede estar sin valor')
            .isInt().withMessage('El ID debe ser un número entero positivo'),
    ],
    dataContactController.DeleteContact
)


// ------------------------
// POST: Login
// ------------------------
router.post(
    '/login',
    [
        body('correo')
            .notEmpty().withMessage('El correo no puede estar vacío')
            .isEmail().withMessage('El correo ingresado no es válido'),

        body('password')
            .notEmpty().withMessage('La contraseña no puede estar vacía')
            .isString().withMessage('La contraseña debe ser un texto')
            .isLength({ min: 8 }).withMessage('La contraseña debe tener al menos 8 caracteres')
            .matches(/(?=.*\d)(?=.*[A-Z])(?=.*[a-z])/)
            .withMessage('La contraseña debe contener mayúsculas, minúsculas y números')
    ],
    dataContactController.login
)


// ------------------------
// GET: Validar email
// ------------------------
router.get(
    '/validarEmail',
    [
        query('correo')
            .notEmpty().withMessage('El correo no puede estar vacío')
            .isEmail().withMessage('Debes ingresar un correo válido'),
    ],
    dataContactController.validarEmail
)


module.exports = router