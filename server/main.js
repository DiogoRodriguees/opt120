const port = 3000;
const express = require("express");
const router = require("./src/routes/routes");
const cors = require("cors");

const server = express();

try {
    server.use(cors());
    server.use(express.json());
    server.use("/", router);

    server.listen(port, () => console.log(`Server running in http://localhost:${port}`));
} catch (error) {
    console.log(error)
    server.response(error)
}
