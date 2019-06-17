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
client.connect(function(err) {
    assert.equal(null, err);
    console.log('Connected to the mongoDB database server.');
    var db = client.db(databaseName);
    var overallFinancesCollection = db.collection("overall_finances_collection");
    var overallFinancesData = overallFinancesCollection.find().toArray()
        .then(function (financeData) {
            return financeData;
        });

    console.log(overallFinancesData);

  /*  cursor.each(function(err, doc) {
        console.log(doc);
    }); */

    client.close();
});

// Handle statically served files on the fileserver.
var app = express();
app.use(express.static(path.join(__dirname, 'templates')));

// Main entry point for web page.
app.get('/', function(req, res) {
    var query = url.parse(req.url, true);
    var filename = query.pathname;
    var filepath = './templates' + filename;
});

app.listen(80);
