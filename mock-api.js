// server.js

// BASE SETUP
// =============================================================================

// call the packages we need
var cors       = require('cors');
var express    = require('express');        // call express
var sleep = require('sleep');               // to simulate slow responses
var app        = express();                 // define our app using express
app.use(cors());
app.options('*', cors());
var bodyParser = require('body-parser');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 3000;        // set our port

// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();              // get an instance of the express Router

//accessed at GET http://localhost:8080/api/processes
router.get('/processes', function(req, res) {
    res.status(200).sendFile(process.cwd() + "/processes.json");
});

router.get('/process/436fdbcf-2505-4483-adc7-88b8e3b7c370', function(req, res) {
    res.status(200).sendFile(process.cwd() + "/p2.json");
});

router.get('/process/e0e86e03-eb25-4ff7-ab48-a7653655e666', function(req, res) {
    sleep.sleep(1);
    res.status(200).sendFile(process.cwd() + "/p1.json");
});

router.post('/process/e0e86e03-eb25-4ff7-ab48-a7653655e666', function(req, res) {
  sleep.msleep(500);
  res.json({ status: 'ok' });
});

router.post('/process/436fdbcf-2505-4483-adc7-88b8e3b7c370', function(req, res) {
  sleep.msleep(500);
  res.json({ status: 'ok' });
});

// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic happens on port ' + port);
