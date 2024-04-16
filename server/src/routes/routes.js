const express = require("express");
const router = express.Router();

const routeAvaliacao = require("./Avaliacao");
const routeAtividades = require("./Atividades");
const routeUsers = require("./Users");

router.use("/usuarios", routeUsers);
router.use("/atividades", routeAtividades);
router.use("/avaliacao", routeAvaliacao);

module.exports = router;
