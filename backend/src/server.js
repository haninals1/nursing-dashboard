const express = require("express");
const cors = require("cors");
const pool = require("./db");

const app = express();
app.use(cors());
app.use(express.json());

// اختبار السيرفر
app.get("/", (req, res) => {
    res.send("Nursing Dashboard API running ✅");
});

// اختبار اتصال قاعدة البيانات
app.get("/test-db", async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT 1 AS ok");
        res.json({ success: true, rows });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, error: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
