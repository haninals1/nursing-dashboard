const jwt = require("jsonwebtoken");

const protect = (req, res, next) => {
    // Authentication middleware logic here
    const token = req.headers.authorization?.split(" ")[1];
    
    if (!token) {
        return res.status(401).json({ success: false, message: "Not authorized, no token provided" });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || "mysecretkey");
        req.user = decoded; // add user to request object
        next();
    } catch (err) {
        res.status(401).json({ success: false, message: "Not authorized, token failed" });
    }
};

module.exports = { protect };
