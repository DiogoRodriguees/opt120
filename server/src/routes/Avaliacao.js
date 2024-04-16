const { AvaliacaoController } = require("../controllers/AvaliacaoController");

const express = require("express");
const routeAvaliacao = express.Router();
const Avaliacao = new AvaliacaoController();

routeAvaliacao.post("/", Avaliacao.atribuir);
routeAvaliacao.get("/", Avaliacao.list);
routeAvaliacao.delete("/", Avaliacao.deleteNota);

module.exports = routeAvaliacao;
