const { database } = require("../database/DatabaseConnection");
const { ResponseDTO } = require("../DTOs/ResponseDTO")
class AtividadesController {

    async create(req, res) {
        console.log(`Trying create atividade: ${JSON.stringify(req.body)}`);

        const atividade = req.body;
        const query = "insert into atividades(titulo, descricao, date) values(?, ?, ?)";
        const queryParams = [atividade.titulo, atividade.descricao, atividade.data]

        const response = database.query(query, queryParams, (err, response) => { { err, response } });

        if (response.err) {
            res.status(404).send(`Erro ao criar atividade`);
        } else {
            res.status(200).send(new ResponseDTO(200, "Atividade criada com sucesso"));
            console.log("Atividade criada com sucesso ...")
        }
    }


    async list(req, res) {
        console.log("Trying list atividades")
        const query = `SELECT a.id, a.titulo, a.descricao, a.date FROM atividades a`

        database.query(query,
            function (err, resp) {
                if (err) {
                    res.status(404).send("Erro ao listar atividades")
                } else {
                    console.log("Success on list atividades")
                    res.status(200).send(new ResponseDTO(200, "Listagem de atividades comcluída", resp));
                }
            }
        );
    }

    async delete(req, res) {
        const { id } = req.query;
        const query = "update atividades set deleted_at = current_timestamp where atividades.id = $1::integer and atividades.deleted_at is null"

        database.query(query, [id],
            function (err, resp) {

                if (err) {
                    res.status(404).send("Não foi deletar atividade.")
                } else {
                    res.status(200).send(`Atividade ${id} deletada`);
                }

            }
        );
    }


}

module.exports = { AtividadesController };
