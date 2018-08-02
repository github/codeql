var robot = require('./robot');
var fs = require('fs');
var parseString = require('xml2js').parseString;

// robotId should be the last 4 characters of the bluetooth address of your Robotis device
// You can see its address on a Mac if you hold down 'option' while viewing the menu bar's bluetooth dropdown

// Example: node src/command.js 1216 19
var args = process.argv.slice(2);
var robotId = args[0]; // e.g. if the address is 'b8-63-bc-00-12-16' your robotId is 1216
var command = args[1] || '1'; // 1 should be set to mean: return to initial position

parseString(fs.readFileSync(__dirname + '/assets/assumedMotionFile.mtnx', { encoding: 'utf8' }), function (err, result)
{
    var flows = result.Root.BucketRoot[0].Bucket[0].callFlows[0].callFlow.map(function (obj) { return obj.$; });
    var flowsByNumber = {};
    flows.forEach(function (flow)
    {
        flowsByNumber[flow.callIndex] = flow.flow;
    });

    // console.log(JSON.stringify(flowsByNumber, null, 2));

    if (command in flowsByNumber)
    {
        console.log('>> ' + flowsByNumber[command]);
        robot.connect(robotId, function onConnect(err)
        {
            robot.sendCommand(Number(command));
        });
    }
    else
    {
        console.log('Unrecognized command: ' + command);
    }
});



