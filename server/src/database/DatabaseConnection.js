const { Client } = require("pg");

const DatabaseCLient = new Client({
    user: "admin",
    password: "admin",
    host: "localhost",
    port: "5432",
    database: "users",
});

DatabaseCLient.connect()
    .then(() => console.log("Connected to PostgreSQL database"))
    .catch((err) => console.error("Error on connect with PostgreSQL DB", err));

module.exports = { DatabaseCLient };
