const jwt = require('jsonwebtoken');

const TAJNA_SVEMIRA = "TAJNA_SVEMIRA";

module.exports = function(req, res, next) {
    const token = req.header('auth-token');
    if(!token) return res.status(401).send("Access denied");
    try
    {
        const verified = jwt.verify(token, TAJNA_SVEMIRA);

        next();
    }
    catch(err)
    {
        res.status(401).send("Access denied");
    }
};