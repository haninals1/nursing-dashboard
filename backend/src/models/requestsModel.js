const pool = require("../db");

// GET all
exports.getAllRequests = async () => {
    const [rows] = await pool.query("SELECT * FROM request");
    return rows;
};

// GET one
exports.getRequestById = async (id) => {
    const [rows] = await pool.query(
        "SELECT * FROM request WHERE request_id = ?",
        [id]
    );
    return rows[0];
};

// CREATE
exports.createRequest = async (data) => {
    const { nurse_id, request_type } = data;

    const [result] = await pool.query(
        `INSERT INTO request (nurse_id, request_type, submission_date, current_status)
     VALUES (?, ?, CURDATE(), 'Pending')`,
        [nurse_id, request_type]
    );

    return result;
};

// UPDATE status
exports.updateStatus = async (id, status) => {
    const [result] = await pool.query(
        "UPDATE request SET current_status=? WHERE request_id=?",
        [status, id]
    );

    return result;
};

// DELETE
exports.deleteRequest = async (id) => {
    const [result] = await pool.query(
        "DELETE FROM request WHERE request_id=?",
        [id]
    );

    return result;
};
