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





//GET /api/productos/:id (Tania)





//POST /api/productos (Tania)





//PUT /api/productos/:id (Oscar)





//DELETE /api/productos/:id (Oscar)







app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});