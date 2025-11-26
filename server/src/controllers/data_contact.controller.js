const { DataContact } = require('../models')
const { validationResult } = require('express-validator')
const bcrypt = require('bcrypt');
const { generateToken } = require('../auth/token_logic')


exports.ViewContacts = async (req, res) => {
    try {

        const view_data_contact = await DataContact.findAll({
            attributes: ['id', 'nombre', 'apellido', 'correo', 'image_url']
        })

        console.log('Mensaje de contacto recibidos con exito!')
        res.status(200).json({ message: 'Datos recibidos con exito', data: view_data_contact })

    } catch (err) {
        console.log('Error al recibir a los contacto', err)
        res.status(500).json({ message: 'Error interno del servidor', Error: err })
    }
}

exports.viewContactById = async (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) return res.status(400).json({ Errors: errors.array() })

    try {
        const { id } = req.params

        const data_contact = await DataContact.findByPk(id, {
            attributes: ['id', 'nombre', 'apellido', 'correo', 'image_url']
        })
        if (!data_contact) return res.status(404).json({ message: `el ID proporcionado ${id} no se encuentra en la bd` })
        console.log('Mensaje de contacto recibido con exito!')
        res.status(200).json({ message: 'Datos recibidos con exito', data: data_contact })

    } catch (err) {
        console.log('Error al recibir al contacto', err)
        res.status(500).json({ message: 'Error interno del servidor', Error: err })
    }
}


exports.CreatePossibleContact = async (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) return res.status(400).json({ Errors: errors.array() })

    try {
        const { nombre, apellido, correo, password } = req.body

        const pass_hash = await bcrypt.hash(password, 12)

        let image_url
        if (req.file && req.file.path) {
            image_url = req.file.path
        }

        if (!req.file) {
            return res.status(400).json({ message: 'Debe subir una imagen' })
        }

        const create_data_contact = await DataContact.create({
            nombre,
            apellido,
            correo,
            image_url,
            password: pass_hash
        })

        console.log('Usuario creado con exito!')
        res.status(201).json({ message: 'Datos almacenados con exito', data: create_data_contact })

    } catch (err) {
        console.log('Error al angregar al contacto', err)
        res.status(500).json({ message: 'Error interno del servidor', Error: err })
    }
}



exports.UpdateContact = async (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) return res.status(400).json({ Errors: errors.array() })

    try {
        const { id } = req.params
        const { nombre, apellido, correo } = req.body

        const data_contact = await DataContact.findByPk(id)
        if (!data_contact) return res.status(404).json({ message: `el ID proporcionado ${id} no se encuentra en la bd` })

        const objectDataContacts = {}

        if (nombre != undefined) objectDataContacts.nombre = nombre
        if (apellido != undefined) objectDataContacts.apellido = apellido
        if (correo != undefined) objectDataContacts.correo = correo

        if (req.file && req.file.path) {
            objectDataContacts.image_url = req.file.path
        }

        await data_contact.update(objectDataContacts)

        const dataUpdated = await DataContact.findByPk(id, {
            attributes: ['id', 'nombre', 'apellido', 'correo', 'image_url']
        })


        console.log('Mensaje de contacto actualizado con exito!')
        res.status(200).json({ message: 'Datos actualizados con exito', data: dataUpdated })

    } catch (err) {
        console.log('Error al angregar al contacto', err)
        res.status(500).json({ message: 'Error interno del servidor', Error: err })
    }
}


exports.DeleteContact = async (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) return res.status(400).json({ Errors: errors.array() })

    try {
        const { id } = req.params

        const data_contact = await DataContact.findByPk(id)
        if (!data_contact) return res.status(404).json({ message: `el ID proporcionado ${id} no se encuentra en la bd` })

        await data_contact.destroy()

        console.log('Mensaje de contacto Eliminado con exito!')
        res.status(200).json({ message: 'Datos eliminados con exito' })

    } catch (err) {
        console.log('Error al eliminar el contacto', err)
        res.status(500).json({ message: 'Error interno del servidor', Error: err })
    }
}


// Login function to authenticate user and generate token

exports.login = async (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() })


    try {

        const { correo, password } = req.body

        const inicioDeSeccion = await DataContact.findOne({
            where: {
                correo
            }
        })

        if (!inicioDeSeccion) return res.status(401).json({ message: 'Correo o contraseña incorrectos' })

        const verifyPassword = await bcrypt.compare(password, inicioDeSeccion.password)

        if (!verifyPassword) return res.status(401).json({ message: 'Contraseña incorrecta' })

        const accessToken = generateToken(inicioDeSeccion)

        res.cookie('accessToken', accessToken, {
            httpOnly: true, // Sirve para que no se pueda acceder a la cookie desde el lado del cliente
            secure: false,
            sameSite: 'lax', // Protege contra ataques CSRF
            maxAge: 8 * 60 * 60 * 1000 // 8 horas
        })

        console.log('inicio de seccion exitoso')
        res.status(200).json({
            message: 'Inicio de sesión exitoso', accessToken, data: {
                id: inicioDeSeccion.id,
                nombre: inicioDeSeccion.nombre,
                apellido: inicioDeSeccion.apellido,
                correo: inicioDeSeccion.correo,
                image_url: inicioDeSeccion.image_url
            }
        })

    } catch (err) {
        console.log('Error al iniciar seccion: ', err)
        res.status(500).json({ message: 'Error interno del servidor', Error: err })
    }
}


exports.validarEmail = async (req, res) => {

    const errors = validationResult(req)
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() })

    try {
        const { correo } = req.query

        const validacion = await DataContact.findOne({
            where: {
                correo
            }
        })

        if (validacion) {
            return res.status(200).json({ existe: true, mensaje: 'Este correo ya está registrado.' });
        } else {
            return res.status(200).json({ existe: false, mensaje: 'Este correo no está registrado.' });
        }

    } catch (err) {
        console.error('Error al verificar el correo:', err);
        res.status(500).json({ err: 'No se pudo verificar el correo.', Error: err });
    }
}





