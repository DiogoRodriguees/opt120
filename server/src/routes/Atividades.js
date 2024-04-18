const { AtividadesController } = require("../controllers/AtividadeController");

const express = require("express");
const routeAtividades = express.Router();
const Atividades = new AtividadesController();

routeAtividades.post("/", Atividades.create);
routeAtividades.get("/", Atividades.list);
routeAtividades.put("/:id", Atividades.update);
routeAtividades.delete("/:id", Atividades.delete);

module.exports = routeAtividades;
