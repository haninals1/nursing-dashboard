const express = require("express");
const nursesRoutes = require("./routes/nursesRoutes");
const requestsRoutes = require("./routes/requestsRoutes");
const approvalRoutes = require("./routes/approvalRoutes");

const app = express();

app.use(express.json());

// test
app.get("/", (req, res) => {
    res.send("Server is working ✅");
});

// nurses API
app.use("/api/nurses", nursesRoutes);
// requests API
app.use("/api/requests", requestsRoutes);
// approval API
app.use("/api/approvals", approvalRoutes);

const PORT = 4000;

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
