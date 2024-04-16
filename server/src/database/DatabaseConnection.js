const mysql = require("mysql8");

const database = mysql.createConnection({
    host: "localhost",
    user: "admin",
    password: "admin",
    database: "devmovel",
});

database.connect();

module.exports = { database };
