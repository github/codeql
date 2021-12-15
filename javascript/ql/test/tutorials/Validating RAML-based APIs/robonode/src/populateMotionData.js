var fs = require('fs');
var parseString = require('xml2js').parseString;

var pageData = {};
var flowData = {};

var MILLIS_PER_FRAME = 8; // This is a guess based on reading docs such as http://support.robotis.com/en/software/roboplus/roboplus_motion/motionedit/stepedit/roboplus_motion_pausetime.htm
var UNIT_PADDING_TIME = 100; // Another guess of how long to wait before motion is truly done
var RECOVERY_TIME = 300; // Another guess of how long to wait before motion is truly done
function elapsedTime(flow)
{
    var millis = 0;
    if (flow.$.return == '-1') // This flow has a finite time and returns
    {
        var units = flow.units[0].unit;
        units.forEach(function (unit)
        {
            var pageName = unit.$.main;
            var steps = pageData[pageName].steps[0].step;
            var lastFrame = Number(steps[steps.length - 1].$.frame);
            millis += (lastFrame * MILLIS_PER_FRAME + UNIT_PADDING_TIME) * unit.$.exitSpeed * unit.$.loop;
            millis += RECOVERY_TIME;
        });
    }
    return millis;
}

module.exports = function populateMotionData(motionData, normalizeCommandName)
{
    motionData.flowsByNumber = {};
    motionData.flowsByName = {};
    parseString(fs.readFileSync(__dirname + '/assets/assumedMotionFile.mtnx', { encoding: 'utf8' }), function (err, parsed)
    {
        motionData.raw = parsed;
        
        // Create a reference map of pages, to use in calculating the elapsed time for each command
        parsed.Root.PageRoot[0].Page.forEach(function (page)
        {
            pageData[page.$.name] = page;
        });

        // Create a reference map of flows
        parsed.Root.FlowRoot[0].Flow.forEach(function (flow)
        {
            flowData[flow.$.name] = flow;
        });

        var callFlows = parsed.Root.BucketRoot[0].Bucket[0].callFlows[0].callFlow;
        callFlows.forEach(function (callFlow)
        {
            var flowNumber = callFlow.$.callIndex;
            var flowName = callFlow.$.flow;
            var flow = flowData[flowName];
            motionData.flowsByNumber[flowNumber] = 
            { 
                name: flowName, 
                time: elapsedTime(flow) 
            };
            motionData.flowsByName[normalizeCommandName(flowName)] = flowNumber;
        });
    });

};

