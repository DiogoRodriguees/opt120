const { database } = require("../database/DatabaseConnection");
const { ResponseDTO } = require("../DTOs/ResponseDTO");


class AvaliacaoController {

    async atribuir(req, res) {
        console.log("Atribuir nota")
        const dados = req.body
        console.log(dados)
        database.query(
            "INSERT INTO usuario_atividade(usuario_id, atividade_id, nota, data_entrega) values(?, ?, ?, ?)",
            [dados.usuario_id, dados.atividade_id, dados.nota, dados.data],
            function (err, response) {
                if (err) {
                    console.log("Falha na avaliacao ...")
                    console.log(err)
                    if (err.code = "ER_DUP_ENTRY") {
                        res.status(404).send(new ResponseDTO(404, `Usuario já foi avaliado`))
                    } else {
                        res.status(404).send(new ResponseDTO(404, `Erro ao avaliar usuário`))
                    }
                } else {
                    console.log("Atribuição de nota realizada ...")
                    res.status(200).send(new ResponseDTO(200, `Usuario avalidado com sucesso`))
                }
            }
        )

    }

    async list(req, res) {

        database.query(
            "select * from usuario_atividade",
            function (err, result) {
                if (!err) {
                    console.log("Listagem de notas realizada ...")
                    res.status(200).send(result)
                } else {
                    res.status(404).send("List notas falhou")
                }
            }
        )
    }

    async deleteNota(req, res) {
        const dados = req.body

        database.query(
            "delete from usuario_atividade where (?) = usuario_id and (?) = atividade_id",
            [dados.usuario_id, dados.atividade_id],
            function (err, result) {
                if (!err) {
                    console.log("Delete  nota completo ...")
                    res.status(200).send(`Delete nota de user ${dados.usuario_id} `)
                } else {
                    res.status(404).send("Delete nota falhou")
                }
            }
        )

    }
}

module.exports = { AvaliacaoController }