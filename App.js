const express = require('express');
const mysql = require('mysql2');
const app = express();
const PORT = 3000;

//Creamos un objeto de conexión con todos los atributos de la conexión
//host, user, password, database
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'ZoeVic12052021',//Usar el password que ustedes configuraron con MYQSL Workbrench
    database: 'almacen_hn'
});

pool.getConnection((error, conexion) => {
    if (error) {
        console.log('Error de conexión a la base de datos');
    }
    else {
        console.log('Conexión exitosa');
    }
});

app.use(express.json());

//GET /api/productos (HUGO)

app.get('/api/almacen_hn',(req,res) => {
    const sql = 'SELECT * FROM productos';
    pool.query(sql,(error,results) =>{
        if(error){
            console.log('Existe un erroe en la consulta SQL');
            res.status(500).json({status: 500, message: 'Error en la consulta SQL'});
        }
        else{
            res.status(200).json({status:200, message: 'Success', data: results});
        }
    });
});


// GET /api/productos/:id (Tania)
app.get('/api/productos/:id', (req, res) => {
    const id = req.params.id;

    const sql = 'SELECT * FROM productos WHERE id = ?';
    
    pool.query(sql, [id], (error, results) => {
        if(error){
            console.log('Error en la consulta SQL');
            return res.status(500).json({status: 500, message: 'Error en la consulta SQL'});
        }

        if(results.length > 0){
            res.status(200).json({status: 200, message: 'Success', data: results[0]});
        } else {
            res.status(404).json({status: 404, message: 'Producto no encontrado'});
        }
    });
});

// POST /api/productos (Tania)
app.post('/api/productos', (req, res) => {
    // Evitar errores si el body viene vacío
    if(!req.body) return res.status(400).json({ status: 400, message: 'Body vacío' });

    const { nombre, descripcion, sku, precio_compra, precio_venta, stock_minimo, estado, category_id, provider_id } = req.body;

    if(!nombre || !sku){
        return res.status(400).json({status: 400, message: 'Nombre y SKU son obligatorios'});
    }

    if(precio_compra <= 0 || precio_venta <= 0){
        return res.status(400).json({status: 400, message: 'Los precios deben ser mayores a 0'});
    }

    const sql = `
        INSERT INTO productos
        (nombre, descripcion, sku, precio_compra, precio_venta, stock_minimo, estado, category_id, provider_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    pool.query(sql, [nombre, descripcion, sku, precio_compra, precio_venta, stock_minimo, estado, category_id, provider_id], (error, results) => {
        if(error){
            console.log('Error al insertar producto:', error);
            return res.status(500).json({status: 500, message: 'Error al crear el producto'});
        }

        res.status(201).json({status: 201, message: 'Producto creado', id: results.insertId});
    });
});

//PUT /api/productos/:id (Oscar)
app.put('/api/productos/:id', (req, res) => {
    const { id } = req.params;
    const campos = ['sku', 'nombre', 'descripcion', 'precio_compra', 'precio_venta', 'stock_minimo', 'estado', 'categoria_id', 'proveedor_id'];
    
    // Filtrar campos que vienen en el body y construir la parte SET
    const updates = campos.filter(c => req.body[c] !== undefined).map(c => `${c} = ?`);
    const values = campos.filter(c => req.body[c] !== undefined).map(c => req.body[c]);
    
    if (updates.length === 0) {
        return res.status(400).json({ mensaje: 'No hay datos para actualizar' });
    }
    
    const sql = `UPDATE productos SET ${updates.join(', ')} WHERE producto_id = ?`;
    pool.query(sql, [...values, id], (err, result) => {
        if (err) {
            if (err.code === 'ER_DUP_ENTRY') return res.status(400).json({ error: 'SKU duplicado' });
            return res.status(500).json({ error: 'Error al actualizar' });
        }
        if (result.affectedRows === 0) return res.status(404).json({ mensaje: 'Producto no encontrado' });
        res.json({ mensaje: 'Producto actualizado' });
    });
});




//DELETE /api/productos/:id (Oscar)
app.delete('/api/productos/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'DELETE FROM productos WHERE producto_id = ?';
    pool.query(sql, [id], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Error al eliminar el producto' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ mensaje: 'Producto no encontrado' });
        }
        res.json({ mensaje: 'Producto eliminado' });
    });
});





app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});