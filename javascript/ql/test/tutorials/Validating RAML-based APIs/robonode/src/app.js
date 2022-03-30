var express = require('express');
var cors = require('cors'); 
var path = require('path');
var osprey = require('osprey');

var robot = require('./robot');
var populateMotionData = require('./populateMotionData');

var app = module.exports = express();

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.compress());
app.use(express.logger('dev'));

// Enable CORS, including preflighting
app.use(cors());
app.options('*', cors());

app.set('port', process.env.PORT || 3000);

function normalizeCommandName(name)
{
    return name.replace(/\s+/g, '').toLowerCase();
}

var motionData = {};
populateMotionData(motionData, normalizeCommandName);

api = osprey.create('/api', app, 
{
  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
  logLevel: 'debug'  //  logLevel: off->No logs | info->Show Osprey modules initializations | debug->Show all
});

// GET information about the commands
api.get('/robots', function (req, res) 
{
    robot.findRobots(function onFound(err, robotDevices)
    {
        if (err)
        {
            res.status(500).send({ error: err });
        }
        else
        {
            res.send(robotDevices);
        }
    });
});

// GET information about the commands
// TODO: One day we'll need to ask the robot for its motion file
// instead of assuming all robots use the assumedMotionFile.mtnx bundled here.
api.get('/robots/:robotId/commands', function (req, res) 
{
    res.send(motionData);
});

// POST a command for the robot to execute
api.post('/robots/:robotId/commands', function (req, res) 
{
    try 
    {

        var robotId = req.params.robotId;
        var commandNumber = req.param('number');
        var commandName = req.param('name');
        var normalizedCommandName = commandName ? normalizeCommandName(commandName) : null;
        var async = req.param('async') || false;


        if (commandName && !commandNumber)
        {
            commandNumber = motionData.flowsByName[normalizedCommandName];
            if (!commandNumber)
            {
                res.status(422).send({ error: 'Unrecognized command name' });
                return;
            }
        }
        
        if (commandNumber in motionData.flowsByNumber)
        {
            var command = motionData.flowsByNumber[commandNumber];
            console.info('Executing command: ' + command.name + ' for ' + command.time + 'ms');
            robot.connect(robotId, function onConnect(err, btSerial)
            {
                if (err)
                {
                    res.status(500).send({ error: err });
                }
                else
                {
                    robot.sendCommand(btSerial, Number(commandNumber));
                    if (async) // respond immediately, with the execution time
                    {
                        console.log('Command sent, not waiting for execution to finish')
                        res.status(202).send({ executionTimeInMs: command.time });
                    }
                    else       // respond only after the execution time has passed
                    {
                        setTimeout(function () 
                        { 
                            console.log('Command sent, finished waiting for execution');
                            res.status(204).send(''); 
                        }, command.time);
                    }
                    
                }
            });
        }
        else
        {
            res.status(422).send({ error: 'Unrecognized command number' });
        }

    } 
    catch (e) 
    { 
        console.error(e); 
        res.status(500).send(''); 
    }
});

// GET the state of the robot by reading the control table at a certain address
// DOES NOT WORK RIGHT YET
// Only asks the robot to read the data, but the data itself is only logged and not returned
api.get('/robots/:robotId/state', function (req, res) 
{
    var robotId = req.params.robotId;
    var address = Number(req.param('address'));
    var bytesToRead = Number(req.param('bytesToRead'));
    console.info('Reading state: ' + [ address, bytesToRead ]);
    robot.connect(robotId, function onConnect(err, btSerial)
    {
        if (err)
        {
            res.status(500).send({ error: err });
        }
        else
        {
            robot.readState(btSerial, address, bytesToRead);
            res.status(202).send('');
        }
    });
});

if (!module.parent) 
{
  var port = app.get('port');
  app.listen(port);
  console.log('listening on port ' + port);
}