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
            console.log(err)
            res.status(404).send(new ResponseDTO(404, `Erro ao criar atividade`));
        } else {
            console.log("Atividade criada com sucesso ...")
            res.status(200).send(new ResponseDTO(200, "Atividade criada com sucesso"));
        }
    }

    async update(req, res) {
        const { id } = req.params
        const { titulo, descricao } = req.body
        console.log(`Trying update atividade ${id}`)

        const query = "update atividades set titulo = ?, descricao = ? where id = ?"
        database.query(query,
            [titulo, descricao, id],
            function (err, resp) {
                if (err) {
                    console.log(err)

                    if (err.code == 'ER_DUP_ENTRY') {
                        res.status(404).send(new ResponseDTO(404, "Email já cadastrado"))
                    } else {
                        res.status(404).send(new ResponseDTO(404, "Erro ao atualizar atividade"))
                    }

                } else {
                    console.log("Success on list atividades")
                    res.status(200).send(new ResponseDTO(200, "Atividade atualizada com sucesso"));
                }
            }
        );
    }

    async list(req, res) {
        console.log("Trying list atividades")
        const query = `SELECT a.id, a.titulo, a.descricao, a.date FROM atividades a where a.deleted_at is null order by a.titulo asc`

        database.query(query,
            function (err, resp) {
                if (err) {
                    console.log(err)
                    res.status(404).send(new ResponseDTO(404, "Erro ao listar atividades"))
                } else {
                    console.log("Success on list atividades")
                    res.status(200).send(new ResponseDTO(200, "Listagem de atividades comcluída", resp));
                }
            }
        );
    }

    async delete(req, res) {
        const { id } = req.params;
        console.log(`Trying delete user ${id}`)
        const query = "update atividades set deleted_at = current_timestamp where atividades.id = ?  and atividades.deleted_at is null"

        database.query(query, [id],
            function (err, resp) {

                if (err) {
                    console.log(err)
                    res.status(404).send(new ResponseDTO(404, "Não foi deletar atividade."))
                } else {
                    console.log(`Atividade ${id} deletada com sucesso`)
                    res.status(200).send(new ResponseDTO(200, `Atividade deletada`));
                }

            }
        );
    }


}

module.exports = { AtividadesController };
