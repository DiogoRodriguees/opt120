const port = 3000;
const express = require("express");
const router = require("./src/routes/routes");
const cors = require("cors");

const server = express();
server.use(cors());
server.use(express.json());
server.use("/", router);

server.listen(port, () => console.log(`Server running in ${port}`));
