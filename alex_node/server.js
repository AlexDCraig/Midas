var url = require('url');
var path = require('path');
var express = require('express');
var app = express();

app.use(express.static(path.join(__dirname, 'templates')));

app.get('/', function(req, res) {
    var query = url.parse(req.url, true);
    var filename = query.pathname;
    var filepath = './templates' + filename;
    res.render(__dirname + filepath);
});

app.listen(8080);
