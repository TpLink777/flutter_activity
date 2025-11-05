const { DataContact } = require('../models')
const { validationResult } = require('express-validator')
const bcrypt = require('bcrypt');

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



exports.CreatePossibleContact = async (req, res) => {

    const errors = validationResult(req)
    console.log(errors.array());
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
    console.log(errors.array());
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
    console.log(errors.array());
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
