const pool = require("../db");

// دالة لجلب الممرضين من قاعدة البيانات (مثال)
const getAllNurses = async () => {
    // const [rows] = await pool.query("SELECT * FROM nursing_staff");
    // return rows;
    return [{ id: 1, name: "Test Nurse" }];
};

module.exports = {
    getAllNurses,
};
