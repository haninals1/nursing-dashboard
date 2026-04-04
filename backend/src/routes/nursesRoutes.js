const express = require("express");
const router = express.Router();
const { getNurses } = require("../controllers/nursesController");

// مسار للحصول على الممرضين (GET /api/nurses)
router.get("/", getNurses);

module.exports = router;
