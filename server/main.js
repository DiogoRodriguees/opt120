const express = require("express");
const port = 3000;
const { Client } = require("pg");
const AtividadesController = require("./src/controllers/AtividadesController.js");

// init and connect postgres database
const dbClient = new Client({
    user: "admin",
    password: "admin",
    host: "localhost",
    port: "5432",
    database: "users",
});

dbClient
    .connect()
    .then(() => console.log("Connected to PostgreSQL database"))
    .catch((err) => console.error("Error on connect with PostgreSQL DB", err));

class UserController {
    async create(req, res) {
        const user = req.body;
        dbClient.query(
            "insert into usuarios(nome, email, senha) values($1::varchar, $2::varchar, $3::varchar)",
            [user.nome, user.email, user.senha]
        );
        res.status(200).send(`Succesffully on create user: ${user}`);
    }
    async list(req, res) {
        dbClient.query("SELECT * FROM usuarios", (err, result) => {
            if (err) res.status(404).send("Erro on select users");
            res.status(200).send(result.rows);
        });
    }
    async update(req, res) {
        res.status(200).send("Route update  - user");
    }
    async delete(req, res) {
        const { id } = req.query;
        console.log(id);
        dbClient.query(
            "update usuarios set deleted_at = current_timestamp where usuarios.id = $1::integer and usuarios.deleted_at is null",
            [id]
        );
        res.status(200).send("Route deleteUser  - user");
    }
}
const server = express();
server.use(express.json());

// initializing classes
const Usuario = new UserController();
const Atividades = new AtividadesController();

// route to users
server.post("/usuarios/create", Usuario.create);
server.put("/usuarios/update", Usuario.update);
server.get("/usuarios/list", Usuario.list);
server.delete("/usuarios/delete", Usuario.delete);

// route to activities
server.post("/atividades/create", Atividades.create);
server.put("/atividades/update", Atividades.update);
server.get("/atividades/list", Atividades.list);
server.delete("/atividades/delete", Atividades.delete);

server.listen(port, () => console.log(`Server running in ${port}`));
