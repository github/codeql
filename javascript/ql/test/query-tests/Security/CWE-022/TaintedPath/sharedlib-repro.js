const fs = require('fs');
const express = require('express');
const app = express();

app.get('/', function (req, res) {
    getTree(req, res, { workspaceDir: '/tmp' });
});

function getTree(req, res, options) {
    var workspaceId = req.params.workspaceId;
    var realfileRootPath = workspaceId; // getfileRoot(workspaceId);
    var filePath = workspaceId; // path.join(options.workspaceDir,realfileRootPath, req.params["0"]);
    withStatsAndETag(req.params.workspaceId, function (err, stats, etag) {});
}

function getfileRoot(workspaceId) {
    var userId = decodeUserIdFromWorkspaceId(workspaceId);
    return path.join(userId.substring(0,2), userId, decodeWorkspaceNameFromWorkspaceId(workspaceId));
}

function withStatsAndETag(filepath, callback) {
	fs.readFileSync(filepath); // NOT OK
};

function decodeUserIdFromWorkspaceId(workspaceId) {
    var index = workspaceId.lastIndexOf(SEPARATOR);
    if (index === -1) return null;
    return workspaceId.substring(0, index);
}

function decodeWorkspaceNameFromWorkspaceId(workspaceId) {
    var index = workspaceId.lastIndexOf(SEPARATOR);
    if (index === -1) return null;
    return workspaceId.substring(index + 1);
}
