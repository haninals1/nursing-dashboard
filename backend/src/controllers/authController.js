const jwt = require("jsonwebtoken");
const { findUserByEmail } = require("../models/userModel");

// دالة تسجيل الدخول
const login = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await findUserByEmail(email);

        if (!user) {
            return res.status(401).json({ success: false, message: "Invalid email or password" });
        }

        // Check password - simple comparison as requested
        const isMatch = password === user.password_hash;

        if (!isMatch) {
            return res.status(401).json({ success: false, message: "Invalid email or password" });
        }

        // Generate JWT Token
        const token = jwt.sign(
            { userId: user.user_id, email: user.email },
            process.env.JWT_SECRET || "mysecretkey",
            { expiresIn: "1h" }
        );

        res.json({
            success: true,
            message: "Login successful",
            token,
            user: { id: user.user_id, email: user.email }
        });

    } catch (err) {
        console.error("Login Error:", err);
        res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    login,
};
