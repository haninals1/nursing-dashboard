const pool = require("../db");

// دالة للبحث عن مستخدم بواسطة الإيميل
const findUserByEmail = async (email) => {
    const [rows] = await pool.query("SELECT * FROM user WHERE email = ?", [email]);
    return rows.length > 0 ? rows[0] : null;
};

module.exports = {
    findUserByEmail,
};
