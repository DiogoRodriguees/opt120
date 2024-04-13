const { AtividadesController } = require("../controllers/AtividadeController");

const express = require("express");
const routeAtividades = express.Router();
const Atividades = new AtividadesController();

routeAtividades.post("/", Atividades.create);
routeAtividades.put("/", Atividades.update);
routeAtividades.get("/", Atividades.list);
routeAtividades.get("/list-title", Atividades.listTitle);
routeAtividades.delete("/", Atividades.delete);

module.exports = routeAtividades;
