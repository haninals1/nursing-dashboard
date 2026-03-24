const express = require("express");
const nursesRoutes = require("./routes/nursesRoutes");

const app = express();

app.use(express.json());

// test
app.get("/", (req, res) => {
    res.send("Server is working ✅");
});

// nurses API
app.use("/api/nurses", nursesRoutes);

const PORT = 4000;

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});