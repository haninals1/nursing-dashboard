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

// Dashboard stats
app.get("/dashboard/stats", async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT k.kpi_name, kv.value
            FROM KPI_value kv
            JOIN KPI k ON kv.kpi_id = k.kpi_id
            WHERE k.kpi_name IN (
                'Patient Satisfaction Score',
                'Number of Complaints',
                'Average Length of Stay',
                'Care Quality Score'
            ) AND kv.unit = 'Overall'
            ORDER BY kv.record_date DESC
        `);
        const stats = {};
        rows.forEach(row => {
            stats[row.kpi_name] = row.value;
        });
        res.json(stats);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// Patient outcomes
app.get("/dashboard/patient-outcomes", async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT kv.unit, k.kpi_name, kv.value, kv.record_date
            FROM KPI_value kv
            JOIN KPI k ON kv.kpi_id = k.kpi_id
            WHERE k.kpi_name IN ('Fall Rate', 'Medication Errors', 'Pressure Injuries')
            ORDER BY kv.record_date ASC
        `);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// Unit satisfaction
app.get("/dashboard/unit-satisfaction", async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT kv.unit, kv.value, kv.record_date
            FROM KPI_value kv
            JOIN KPI k ON kv.kpi_id = k.kpi_id
            WHERE k.kpi_name = 'Patient Satisfaction Score'
            AND kv.unit != 'Overall'
            ORDER BY kv.unit
        `);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// Training needs
app.get("/dashboard/training-needs", async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT tp.training_name,
            COUNT(st.nurse_id) as total,
            SUM(CASE WHEN st.status = 'Completed' THEN 1 ELSE 0 END) as completed
            FROM Training_program tp
            LEFT JOIN Staff_training st ON tp.training_id = st.training_id
            GROUP BY tp.training_id, tp.training_name
        `);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// Notifications
app.get("/notifications", async (req, res) => {
    res.json([]);
});

// Login
app.post("/login", async (req, res) => {
    const { email, password } = req.body;
    try {
        const [users] = await pool.query(
            `SELECT u.user_id, u.email, u.password_hash, u.account_status,
              ns.full_name, ns.job_title, ns.unit,
              r.role_name
       FROM user u
       LEFT JOIN nursing_staff ns ON u.user_id = ns.user_id
       LEFT JOIN userrole ur ON u.user_id = ur.user_id
       LEFT JOIN role r ON ur.role_id = r.role_id
       WHERE u.email = ?`,
            [email]
        );

        if (users.length === 0) {
            return res.status(401).json({ error: "Invalid email or password" });
        }

        const user = users[0];

        if (password !== user.password_hash) {
            return res.status(401).json({ error: "Invalid email or password" });
        }

        res.json({
            user_id: user.user_id,
            full_name: user.full_name,
            job_title: user.job_title,
            unit: user.unit,
            role: user.role_name,
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});