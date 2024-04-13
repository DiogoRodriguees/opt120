const { UserController } = require("../controllers/UsuarioController");

const express = require("express");
const routeUsers = express.Router();
const Usuario = new UserController();

routeUsers.post("/", Usuario.create);
routeUsers.put("/", Usuario.update);
routeUsers.get("/", Usuario.list);
routeUsers.delete("/", Usuario.delete);

module.exports = routeUsers;
