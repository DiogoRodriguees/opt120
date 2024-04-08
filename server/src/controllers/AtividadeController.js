const { DatabaseCLient } = require("../database/DatabaseConnection");

class AtividadesController {
    async create(req, res) {
        const atividade = req.body;
        console.log(`Trying create atividade: ${JSON.stringify(atividade)}`);
        DatabaseCLient.query(
            "insert into atividades(titulo, descricao, date) values($1::varchar, $2::varchar, $3::timestamp)",
            [atividade.titulo, atividade.descricao, new Date()]
        );
        res.status(200).send(`Succesffully on create activities: ${atividade}`);
    }

    async list(req, res) {
        DatabaseCLient.query("SELECT * FROM atividades", (err, result) => {
            if (err) res.status(404).send("Erro on select users");
            res.status(200).send(result.rows);
        });
    }

    async listTitle(req, res) {
        console.log(`Trying list activities title`);
        DatabaseCLient.query(
            "SELECT atividades.titulo FROM atividades",
            (err, result) => {
                if (err) res.status(404).send("Erro on select users");
                console.log(`Retuning title list: ${new Date()}`);
                res.status(200).send(result.rows);
            }
        );
    }
    async update(req, res) {
        res.status(200).send("Route update  - user");
    }
    async delete(req, res) {
        const { id } = req.query;
        console.log(id);
        DatabaseCLient.query(
            "update atividades set deleted_at = current_timestamp where atividades.id = $1::integer and atividades.deleted_at is null",
            [id]
        );
        res.status(200).send("Route deleteUser  - atividade");
    }
}

module.exports = { AtividadesController };
