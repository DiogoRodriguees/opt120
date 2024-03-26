const { UserController } = require("../controllers/UsuarioController");

const express = require("express");
const routeUsers = express.Router();
const Usuario = new UserController();

routeUsers.post("/create", Usuario.create);
routeUsers.put("/update", Usuario.update);
routeUsers.get("/list", Usuario.list);
routeUsers.delete("/delete", Usuario.delete);

module.exports = routeUsers;
