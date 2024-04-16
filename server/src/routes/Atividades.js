const { AtividadesController } = require("../controllers/AtividadeController");

const express = require("express");
const routeAtividades = express.Router();
const Atividades = new AtividadesController();

routeAtividades.post("/", Atividades.create);
routeAtividades.get("/", Atividades.list);
routeAtividades.delete("/", Atividades.delete);

module.exports = routeAtividades;
