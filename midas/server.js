var assert = require('assert');
var url = require('url');
var path = require('path');
var express = require('express');

// Handle command line arguments to server.js.
var argv = require('minimist')(process.argv.slice(2));
var mongoAccessorString = "mongodb://" + argv["database_info"];

// Handle database interactions.
// For local testing: run a mongodb instance either in the background or another window.
// For example, on Windows, this looks like: C:\"Program Files"\MongoDB\Server\4.0\bin\mongo.exe
// You can then see the UI in your browser with 127.0.0.1/x.
var MongoClient = require('mongodb').MongoClient;
var databaseName = "financial_data_db";
var client = new MongoClient(mongoAccessorString);
var db = null;
var overallFinancesCollection = null;

client.connect(function(err) {
    assert.equal(null, err);
    console.log('Connected to the mongoDB database server.');
    db = client.db(databaseName);
    overallFinancesCollection = db.collection("overall_finances_collection");
});

var overallDataPromise = () => (
    new Promise((resolve, reject) => {
        overallFinancesCollection.find().toArray()
            .then(function(result){
                resolve(result);
            })
            .catch(function(err) {
                console.log(err);
            });
        })
);

// Handle statically served files on the fileserver.
var app = express();
app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'templates')));

// Set up Prometheus instrumentation for app performance.
const Prometheus = require('prom-client');
var responseTime = require('response-time')

const httpRequestDurationMicroseconds = new Prometheus.Histogram({
  name: 'http_request_duration_ms',
  help: 'Duration of HTTP requests in ms',
  labelNames: ['route'],
  // RT in interval [0.1, 500] ms
  buckets: [0.10, 5, 15, 50, 100, 200, 300, 400, 500]
});

app.use(responseTime(function(req, res, time) {
    try {
        httpRequestDurationMicroseconds
        .labels(req.route.path)
        .observe(time);
    } catch (error) {
        console.log(error);
    }
}));

// Entry point for main web page.
app.get('/home', function(req, res) {
    overallDataPromise().then(function(result) {
        res.render('home.ejs', { overallFinancialSeries: result });
    });
});

// Endpoint to view Prometheus metrics.
app.get('/metrics', (req, res) => {
  res.set('Content-Type', Prometheus.register.contentType)
  res.end(Prometheus.register.metrics())
})

app.listen(80);
