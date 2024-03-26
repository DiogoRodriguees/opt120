const { AtividadesController } = require("../controllers/AtividadeController");

const express = require("express");
const routeAtividades = express.Router();
const Atividades = new AtividadesController();

routeAtividades.post("/create", Atividades.create);
routeAtividades.put("/update", Atividades.update);
routeAtividades.get("/list", Atividades.list);
routeAtividades.delete("/delete", Atividades.delete);

module.exports = routeAtividades;
