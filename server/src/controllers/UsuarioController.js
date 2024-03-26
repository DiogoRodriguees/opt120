const { DatabaseCLient } = require("../database/DatabaseConnection");

class UserController {
    async create(req, res) {
        const user = req.body;
        DatabaseCLient.query(
            "insert into usuarios(nome, email, senha) values($1::varchar, $2::varchar, $3::varchar)",
            [user.nome, user.email, user.senha]
        );
        res.status(200).send(`Succesffully on create user: ${user}`);
    }
    async list(req, res) {
        DatabaseCLient.query("SELECT * FROM usuarios", (err, result) => {
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
        DatabaseCLient.query(
            "update usuarios set deleted_at = current_timestamp where usuarios.id = $1::integer and usuarios.deleted_at is null",
            [id]
        );
        res.status(200).send("Route deleteUser  - user");
    }
}

module.exports = { UserController };
