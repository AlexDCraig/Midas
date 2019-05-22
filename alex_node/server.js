var http = require('http');
var fs = require('fs');

var handleRequest = function(request, response) {
    fs.readFile('templates/home.html', function(err, data) {
        response.writeHead(200, {'Content-Type': 'text/html'});
	response.write(data);
	response.end();
    });
};

var www = http.createServer(handleRequest);
www.listen(8080);

