var assert = require('assert');
var url = require('url');
var path = require('path');
var express = require('express');

// Handle command line arguments to server.js.
var argv = require('minimist')(process.argv.slice(2));
var mongoAccessorString = "mongodb://" + argv["database_info"];

// Handle database interactions.
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

// Main entry point for web page.
app.get('/home', function(req, res) {
    overallDataPromise().then(function(result) {
        res.render('home.ejs', { overallFinancialSeries: result });
    });
});

app.listen(80);
