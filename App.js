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




//GET /api/productos/:id (Tania)





//POST /api/productos (Tania)





//PUT /api/productos/:id (Oscar)





//DELETE /api/productos/:id (Oscar)







app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});