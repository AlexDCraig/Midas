var http = require('http');
var url = require('url');
var fs = require('fs');
var path = require('path');
var express = require('express');
var header = {'Content-Type': 'text/html'};
var app = express();
app.use(express.static(path.join(__dirname, 'templates')));

http.createServer(function (request, response) {
    var query = url.parse(request.url, true);
    var filename = query.pathname;
    var filepath = './templates' + filename;
    fs.readFile(filepath, function (error, data) {
        if (error) {
            response.writeHead(404, header);
            return response.end("404 Not Found");
        }
        response.writeHead(200, header);
        response.write(data);
        return response.end();
    });
}).listen(8080);
