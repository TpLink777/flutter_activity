const express = require('express')
const router = express.Router()
const dataContactController = require('../controllers/data_contact.controller')

const { body, param } = require('express-validator')

router.get('/findInformationData', dataContactController.ViewContacts)


router.post('/add-data-contact', [
    body('nombre')
        .notEmpty().withMessage('El nombre no puede estar vacío')
        .isString().withMessage('El nombre debe ser un texto'),
    body('apellido')
        .notEmpty().withMessage('El apellido no puede estar vacío')
        .isString().withMessage('El apellido debe ser un texto'),
    body('correo')
        .notEmpty().withMessage('El correo no puede estar vacío')
        .isEmail().withMessage('El correo ingresado no es válido'),
    body('mensaje')
        .notEmpty().withMessage('El mensaje no puede estar vacío')
        .isString().withMessage('El mensaje debe ser un texto'),
], dataContactController.CreatePossibleContact)


router.put('/updated-information/:id', [
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

], dataContactController.UpdateContact)


router.delete('/delete-information/:id', [
    param('id')
        .notEmpty().withMessage('El ID no puede estar sin valor')
        .isInt().withMessage('El ID debe ser un número entero positivo'),
], dataContactController.DeleteContact) 


module.exports = router