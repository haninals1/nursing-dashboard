const model = require("../models/requestsModel");

exports.getAll = async (req, res) => {
    try {
        const data = await model.getAllRequests();
        res.json(data);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

exports.getOne = async (req, res) => {
    try {
        const data = await model.getRequestById(req.params.id);
        res.json(data);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

exports.create = async (req, res) => {
    try {
        const result = await model.createRequest(req.body);
        res.json(result);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};


exports.updateStatus = async (req, res) => {
    try {
        const result = await model.updateStatus(
            req.params.id,
            req.body.status
        );
        res.json(result);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

exports.remove = async (req, res) => {
    try {
        const result = await model.deleteRequest(req.params.id);
        res.json(result);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};
