const { UserController } = require("../controllers/UsuarioController");

const express = require("express");
const routeUsers = express.Router();
const Usuario = new UserController();

routeUsers.post("/", Usuario.create);
routeUsers.get("/", Usuario.list);
routeUsers.put("/", Usuario.update);
routeUsers.delete("/:id", Usuario.delete);

module.exports = routeUsers;
