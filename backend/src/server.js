const express = require("express");

const app = express();

app.get("/", (req, res) => {
    res.send("Nursing Dashboard API running ✅");
});

const PORT = 3000;

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
