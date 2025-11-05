const { DataContact } = require('../models')
const { validationResult } = require('express-validator')



exports.ViewContacts = async (req, res) => {
    try {

        const view_data_contact = await DataContact.findAll({
            attributes: ['id', 'nombre', 'apellido', 'correo']
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
    if (!errors.isEmpty()) return res.status(400).json({ Errors: errors.array() })

    try {
        const { nombre, apellido, correo, mensaje } = req.body

        const create_data_contact = await DataContact.create({
            nombre,
            apellido,
            correo,
            mensaje
        })

        console.log('Mensaje de contacto guardado con exito!')
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

        await data_contact.update(objectDataContacts)

        const dataUpdated = await DataContact.findByPk(id, {
            attributes: ['id', 'nombre', 'apellido', 'correo']
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
