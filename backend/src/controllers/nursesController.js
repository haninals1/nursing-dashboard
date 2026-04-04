const { getAllNurses } = require("../models/nursesModel");

const getNurses = async (req, res) => {
    try {
        const nurses = await getAllNurses();
        res.json({ success: true, data: nurses });
    } catch (err) {
        console.error("Error fetching nurses:", err);
        res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    getNurses,
};
