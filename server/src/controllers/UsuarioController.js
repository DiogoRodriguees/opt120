const { database } = require("../database/DatabaseConnection");
const { ResponseDTO } = require("../DTOs/ResponseDTO")

class UserController {
    async create(req, res) {
        console.log(`Trying create user ${JSON.stringify(req.body)}`);

        const user = req.body;
        const query = "insert into usuarios(nome, email, senha) values(?,?, ?)"
        const params = [user.nome, user.email, user.senha]

        database.query(query, params,
            function (err, response) {
                if (err) {
                    console.log(err)
                    if (err.code == "ER_DUP_ENTRY") {
                        res.status(404).send(new ResponseDTO(404, "Email já foi cadastrado"));
                    } else {
                        res.status(404).send(new ResponseDTO(404, "Erro ao criar usuario"));
                    }
                } else {
                    console.log(`Create user ${user.nome} complete ...`);
                    res.status(200).send(new ResponseDTO(200, "Usuário criado com sucesso"));
                }
            }
        );

    }

    async list(req, res) {
        console.log("Trying list users ...");
        const query = "SELECT u.id, u.nome, u.email, u.senha FROM usuarios u"

        database.query(query,
            function (err, response) {
                if (err) {
                    res.status(404).send(new ResponseDTO(404, "Erro ao listar usuários"));
                } else {
                    console.log("List users complete ...");
                    res.status(200).send(new ResponseDTO(200, "Listagem de usuários concluída", response));
                }
            });
    }

    async delete(req, res) {
        const { id } = req.query;
        console.log(id);
        database.query(
            "update usuarios set deleted_at = current_timestamp where usuarios.id = $1::integer and usuarios.deleted_at is null",
            [id]
        );
        res.status(200).send("Route deleteUser  - user");
    }
}

module.exports = { UserController };
