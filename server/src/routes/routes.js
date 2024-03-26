const express = require("express");
const router = express.Router();

const routeAtividades = require("./Atividades");
const routeUsers = require("./Users");

router.use("/usuarios", routeUsers);
router.use("/atividades", routeAtividades);

module.exports = router;
