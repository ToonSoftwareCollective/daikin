import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {

    property url menuScreenUrl : "DaikinSettings.qml"
    property DaikinSettings daikinSettings

    property url daikinEnergyUrl : "DaikinEnergy.qml"
    property DaikinEnergy daikinEnergy

    property url daikinGraphsUrl : "DaikinGraphs.qml"
    property DaikinGraphs daikinGraphs

    property url controlScreenUrl : "DaikinControl.qml"
    property DaikinControl daikinControl

    property url tileUrl : "DaikinTile.qml"
    property DaikinTile daikinTile


// tile update variables

    property string update_interval
    property bool showCountDown;

// data on max 4 daikins

    property int     daikinCount
    property variant daikinNames : []
    property variant daikinIPs : []
    property variant daikinPorts : []

// communication status

    property variant asynchronous_com : [ ]

// variable to receive data from Daikin

    property variant xmlhttpSensor
    property variant xmlhttpControl

    property string daikinSensorData
    property string daikinControlData
    property string daikinEnergyData

    property variant dataSensorJSON
    property variant dataControlJSON
    property variant dataEnergyJSON

// variable to set controls in Daikin

    property string daikinSetControlData
    property variant dataSetControlJSON

// actual sensor and control

    property string homeTemp        : "-"
    property string directionTemp   : "-"
    property string targetTemp      : "-"
    property string roofTemp        : "-"

// control set variables received

    property bool pow               : false
    property string mode            : "-"
    property string stemp           : "-"
    property string shum            : "-"
    property string f_rate          : "-"
    property string f_dir           : "-"

// control set variable values to send back (from received reference data per mode)

    property string modevalue
    property string stempvalue
    property string shumvalue
    property string f_ratevalue
    property string f_dirvalue

// Energy usage variables

// these contain 12 months each and are used to calculate....
    property variant curr_year_heat : []
    property variant prev_year_heat : []
    property variant curr_year_cool : []
    property variant prev_year_cool : []
// these .... only the last 12 months are shown in the graphs
    property variant last_year_heat : []
    property variant last_year_cool : []
    property variant last_year_energy : []

// The next is in the config already but not in use
// The idea is to use a configurable background picture for each airco

    property variant daikinPictures : []

// -------------------------------------- Location of user settings file

    FileIO {
        id: userSettingsFile
        source: "file:///mnt/data/tsc/daikin.userSettings.json"
     }

// -------------------------- Structure user settings from settings file

    property variant userSettingsJSON : {}

// ----------------------------------------------- Load APP requirements

    function init() {

        const args = {
            thumbCategory: "general",
            thumbLabel: "Daikin",
            thumbIcon: "qrc:/tsc/fan_on.png",
            thumbIconVAlignment: "center",
            thumbWeight: 30
        }

        registry.registerWidget("tile", tileUrl, this, "daikinTile", args);

        registry.registerWidget("screen", controlScreenUrl, this, "daikinControl");

        registry.registerWidget("screen", menuScreenUrl, this, "daikinSettings");

        registry.registerWidget("screen", daikinEnergyUrl, this, "daikinEnergy");

        registry.registerWidget("screen", daikinGraphsUrl, this, "daikinGraphs");
    }

// ------------------------------------- Actions right after APP startup

    Component.onCompleted: {

// read user settings

        try {
            userSettingsJSON = JSON.parse(userSettingsFile.read());

            update_interval = userSettingsJSON['interval'];
            showCountDown   = (userSettingsJSON['ShowCountDown'] == "yes") ? true : false
            daikinCount     = userSettingsJSON['daikinCount'];
            daikinNames     = userSettingsJSON['daikinNames'].slice()
            daikinIPs       = userSettingsJSON['daikinIPs'].slice()
            daikinPorts     = userSettingsJSON['daikinPorts'].slice()
            daikinPictures  = userSettingsJSON['daikinPictures'].slice()

            asynchronous_com = [ false, false, false, false ]

        } catch(e) {

            update_interval = "10"
            showCountDown   = false
            daikinCount     = 4
            daikinNames     = ["Daikin 1","Daikin 2","Daikin 3","Daikin 4"]
            daikinIPs       = ["","","",""]
            daikinPorts     = ["80","80","80","80"]
            daikinPictures  = ["daikin1.png","daikin2.png","daikin3.png","daikin4.png"]

            asynchronous_com = [ true, true, true, true ]
        }
    }

// ---------------------------------------------------------------------

    function saveSettings(){

         var tmpUserSettingsJSON = {
            "interval":         update_interval,
            "daikinCount":      daikinCount,
            "daikinNames":      daikinNames,
            "daikinIPs":        daikinIPs,
            "daikinPorts":      daikinPorts,
            "daikinPictures":   daikinPictures,
            "ShowCountDown":    (showCountDown) ? "yes" : "no"
        }
        var daikinSettingsFile = new XMLHttpRequest();
        daikinSettingsFile.open("PUT", "file:///mnt/data/tsc/daikin.userSettings.json");
        daikinSettingsFile.send(JSON.stringify(tmpUserSettingsJSON));
    }

// ---------------------------------------------------------------------

    function log(tolog) {

        var now      = new Date();
        var dateTime = now.getFullYear() + '-' +
                ('00'+(now.getMonth() + 1)   ).slice(-2) + '-' +
                ('00'+ now.getDate()         ).slice(-2) + ' ' +
                ('00'+ now.getHours()        ).slice(-2) + ":" +
                ('00'+ now.getMinutes()      ).slice(-2) + ":" +
                ('00'+ now.getSeconds()      ).slice(-2) + "." +
                ('000'+now.getMilliseconds() ).slice(-3);
        console.log(dateTime+' daikin : ' + tolog.toString())

    }

// ---------------------------------------------------------------------

    function readDaikinData(di)  {

// When in error state we communicate in async mode and may need to kill previous async retry.

        if (typeof xmlhttpSensor != "undefined") { xmlhttpSensor.abort() }

// di :: daikin index 0..4

        var ipAddress = daikinIPs[di]
        var httpPort = daikinPorts[di]

        var connectionPath = ipAddress + ":" + httpPort;

        if ( connectionPath.length > 4 ) {

// get sensor info

            xmlhttpSensor = new XMLHttpRequest();

            xmlhttpSensor.open("GET", "http://"+connectionPath+"/aircon/get_sensor_info", asynchronous_com[di]);

            xmlhttpSensor.onreadystatechange = function() {

                if (xmlhttpSensor.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpSensor.status === 200) {

                        asynchronous_com[di] = false

                        daikinSensorData = '{"' + xmlhttpSensor.response.split('=').join('":"').split(',').join('","') + '"}';

                        dataSensorJSON = JSON.parse(daikinSensorData);

                        var newhomeTemp = dataSensorJSON['htemp'].slice(0, -2)

                        var newroofTemp = dataSensorJSON['otemp'].slice(0, -2)

                        if ( newroofTemp.length > 0 ) {
                            roofTemp = newroofTemp
                        }

                        homeTemp = newhomeTemp

                    } else {

                        asynchronous_com[di] = true
                        log("http://"+connectionPath+"/aircon/get_sensor_info Return status: " + xmlhttpSensor.status)
                    }
                }
            }

            xmlhttpSensor.send();

// get control info

            xmlhttpControl = new XMLHttpRequest();

            xmlhttpControl.open("GET", "http://"+connectionPath+"/aircon/get_control_info", asynchronous_com[di]);

            xmlhttpControl.onreadystatechange = function() {

                if (xmlhttpControl.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpControl.status === 200) {

                        asynchronous_com[di] = false

                        daikinControlData = '{"' + xmlhttpControl.response.split('=').join('":"').split(',').join('","') + '"}';

                        dataControlJSON = JSON.parse(daikinControlData);

// Variables for Tile have Tile in them -> possibility to act different on Tile

                        switch (dataControlJSON['mode']) {
                        case "0":
                        case "1":
                        case "7":
                            directionTemp = ">"
                            targetTemp = dataControlJSON['stemp'].slice(0, -2);
                            break;
                        case "2":
                            directionTemp = "="
// a target temperature is 'not applicable' but for the layout on the tile I think it is better to show something
//                            targetTemp = "na";
                            targetTemp = homeTemp;
                            break;
                        case "3":
                            directionTemp = "v"
                            targetTemp = dataControlJSON['stemp'].slice(0, -2);
                            break;
                        case "4":
                            directionTemp = "^"
                            targetTemp = dataControlJSON['stemp'].slice(0, -2);
                            break;
                        case "6":
                            directionTemp = "="
// a target temperature is 'not applicable' but for the layout on the tile I think it is better to show something
//                            targetTemp = "na";
                            targetTemp = homeTemp;
                            break;
                        }

                        pow = (dataControlJSON['pow'] == "1") ? true : false
                        mode = dataControlJSON['mode']
                        f_rate = dataControlJSON['f_rate']
                        f_dir = dataControlJSON['f_dir']
                        stemp = dataControlJSON['stemp']
                        shum = dataControlJSON['shum']

                    } else {
                        asynchronous_com[di] = true
                        log("http://"+connectionPath+"/aircon/get_control_info Return status: " + xmlhttpControl.status)
                    }
                }
            }

            xmlhttpControl.send();

        } else {
            asynchronous_com[di] = true
        }

        if (asynchronous_com[di]) {
            homeTemp = "-"
            directionTemp = "-"
            targetTemp = "-"
            roofTemp =  "-"
            pow = false
            mode = "-"
            f_rate = "-"
            f_dir = "-"
            stemp = "-"
            shum = "-"
        }
    }

// ---------------------------------------------------------------------

    function setDaikinControl(di, which, value)  {

// di       :: daikin index 0..4
// which    :: setting to change
// value    :: value for the setting

        var ipAddress = daikinIPs[di]
        var httpPort = daikinPorts[di]

        var connectionPath = ipAddress + ":" + httpPort;

        if ( ( connectionPath.length > 4 ) && ( ! asynchronous_com[di] ) ) {

// get control info

            var xmlhttpSetControlGet = new XMLHttpRequest();

            xmlhttpSetControlGet.open("GET", "http://"+connectionPath+"/aircon/get_control_info", asynchronous_com[di]);

            xmlhttpSetControlGet.onreadystatechange = function() {

                if (xmlhttpSetControlGet.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpSetControlGet.status === 200) {

                        asynchronous_com[di] = false

                        daikinSetControlData = xmlhttpSetControlGet.response;

                        dataSetControlJSON = JSON.parse('{"' + xmlhttpSetControlGet.response.split('=').join('":"').split(',').join('","') + '"}');

                    } else {
                        asynchronous_com[di] = true
                        log("http://"+connectionPath+"/aircon/get_control_info Return status: " + xmlhttpSetControlGet.status)
                    }
                }
            }

            xmlhttpSetControlGet.send();

// ------ build newControls

            var newControls = {}

            newControls['pow'] = dataSetControlJSON['pow']
            newControls['f_rate'] = dataSetControlJSON['f_rate']
            newControls['f_dir'] = dataSetControlJSON['f_dir']
            newControls['stemp'] = dataSetControlJSON['stemp']
            newControls['shum'] = dataSetControlJSON['shum']
            newControls['mode'] = dataSetControlJSON['mode']

            newControls[which] = value

            if (which == "mode") {

                switch(value){
                case "0":
                    newControls['stemp']   = dataSetControlJSON['dt1']
                    newControls['shum']    = dataSetControlJSON['dh1']
                    newControls['f_rate']  = dataSetControlJSON['dfr1']
                    newControls['f_dir']   = dataSetControlJSON['dfd1']
                    break;
                case "2":
                case "3":
                case "4":
                    newControls['stemp']   = dataSetControlJSON['dt'+value]
                    newControls['shum']    = dataSetControlJSON['dh'+value]
                    newControls['f_rate']  = dataSetControlJSON['dfr'+value]
                    newControls['f_dir']   = dataSetControlJSON['dfd'+value]
                    break;
                case "6":
                    newControls['stemp']   = '--'
                    newControls['shum']    = '--'
                    newControls['f_rate']  = dataSetControlJSON['dfr'+value]
                    newControls['f_dir']   = dataSetControlJSON['dfd'+value]
              }

            }

            daikinSetControlData = "pow=" + JSON.stringify(newControls['pow'])

            daikinSetControlData = daikinSetControlData  + "&mode=" + JSON.stringify(newControls['mode'])
            daikinSetControlData = daikinSetControlData  + "&stemp=" + JSON.stringify(newControls['stemp'])
            daikinSetControlData = daikinSetControlData  + "&shum=" + JSON.stringify(newControls['shum'])
            daikinSetControlData = daikinSetControlData  + "&f_rate=" + JSON.stringify(newControls['f_rate'])
            daikinSetControlData = daikinSetControlData  + "&f_dir=" + JSON.stringify(newControls['f_dir'])

// remove double quotes

            daikinSetControlData = daikinSetControlData.replace(/\"/g,"")

// send the control back

            var xmlhttpSetControlSet = new XMLHttpRequest();

            xmlhttpSetControlSet.open("GET", "http://"+connectionPath+"/aircon/set_control_info?" + daikinSetControlData , asynchronous_com[di]);

              xmlhttpSetControlSet.onreadystatechange = function() {

                  if (xmlhttpSetControlSet.readyState == XMLHttpRequest.DONE) {

                      if (xmlhttpSetControlSet.status === 200) {

                        asynchronous_com[di] = false

                        daikinSetControlData = xmlhttpSetControlSet.response;

                      } else {
                        asynchronous_com[di] = true
                        log("http://"+connectionPath+"/aircon/set_control_info?" + daikinSetControlData + " Return status: " + xmlhttpSetControlSet.status)
                      }
                  }
              }

            xmlhttpSetControlSet.send();

            xmlhttpSetControlGet = null
            xmlhttpSetControlSet = null

        }
    }

// ---------------------------------------------------------------------

    function readDaikinEnergy(di)  {

        curr_year_heat[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        prev_year_heat[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        curr_year_cool[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        prev_year_cool[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]

// di :: daikin index 0..4

        var ipAddress = daikinIPs[di]
        var httpPort = daikinPorts[di]

        var connectionPath = ipAddress + ":" + httpPort;

        if ( ( connectionPath.length > 4 ) && ( ! asynchronous_com[di] ) )  {

// get usage info

            var xmlhttpEnergy = new XMLHttpRequest();

            xmlhttpEnergy.open("GET", "http://"+connectionPath+"/aircon/get_year_power_ex", asynchronous_com[di]);

            xmlhttpEnergy.onreadystatechange = function() {

                if (xmlhttpEnergy.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpEnergy.status === 200) {

                        asynchronous_com[di] = false

                        daikinEnergyData = '{"' + xmlhttpEnergy.response.split('=').join('":"').split(',').join('","') + '"}';

                        dataEnergyJSON = JSON.parse(daikinEnergyData);

                        var stringArray = JSON.stringify(dataEnergyJSON['curr_year_heat']).replace(/"/g, '').split("/")
                        var i = 0
                        for ( i = 0 ; i < 12 ; i++ ) {
                            curr_year_heat[di][i] = parseFloat(stringArray[i]) / 10
                        }

                        var stringArray = JSON.stringify(dataEnergyJSON['curr_year_cool']).replace(/"/g, '').split("/")
                        var i = 0
                        for ( i = 0 ; i < 12 ; i++ ) {
                            curr_year_cool[di][i] = parseFloat(stringArray[i]) / 10
                        }

                        var stringArray = JSON.stringify(dataEnergyJSON['prev_year_heat']).replace(/"/g, '').split("/")
                        var i = 0
                        for ( i = 0 ; i < 12 ; i++ ) {
                            prev_year_heat[di][i] = parseFloat(stringArray[i]) / 10
                        }

                        var stringArray = JSON.stringify(dataEnergyJSON['prev_year_cool']).replace(/"/g, '').split("/")
                        var i = 0
                        for ( i = 0 ; i < 12 ; i++ ) {
                            prev_year_cool[di][i] = parseFloat(stringArray[i]) / 10
                        }
                    } else {
                        asynchronous_com[di] = true
                        log("http://"+connectionPath+"/aircon/get_year_power_ex Return status: " + xmlhttpEnergy.status)
                    }
                }
            }
            xmlhttpEnergy.send();

            xmlhttpEnergy = null
        }
    }

// ---------------------------------------------------------------------

    function calculateEnergy()  {

        var d = new Date();
        var n = d.getMonth();

// Fill 5 arrays with 0's and only calculate totals for actual number of airco's

        last_year_energy[4] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        for ( var i = 0 ; i < 4 ; i ++) {

            last_year_heat[i] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            last_year_cool[i] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            last_year_energy[i] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

            if ( i < daikinCount ) {

                for ( var ma = 0 ; ma <= n ; ma++ ) {
                    last_year_heat[i][ma] = last_year_heat[i][ma] + curr_year_heat[i][ma]
                    last_year_cool[i][ma] = last_year_cool[i][ma] + curr_year_cool[i][ma]

                    last_year_energy[i][ma] = last_year_energy[i][ma] + curr_year_heat[i][ma]
                    last_year_energy[i][ma] = last_year_energy[i][ma] + curr_year_cool[i][ma]

                    last_year_heat[i][ma] = Math.round(last_year_heat[i][ma] * 10) / 10
                    last_year_cool[i][ma] = Math.round(last_year_cool[i][ma] * 10) / 10
                    last_year_energy[i][ma] = Math.round(last_year_energy[i][ma] * 10) / 10
                }

                for ( var mb = n + 1 ; mb < 12 ; mb++ ) {
                    last_year_heat[i][mb] = last_year_heat[i][mb] + prev_year_heat[i][mb]
                    last_year_cool[i][mb] = last_year_cool[i][mb] + prev_year_cool[i][mb]

                    last_year_energy[i][mb] = last_year_energy[i][mb] + prev_year_heat[i][mb]
                    last_year_energy[i][mb] = last_year_energy[i][mb] + prev_year_cool[i][mb]

                    last_year_heat[i][mb] = Math.round(last_year_heat[i][mb] * 10) / 10
                    last_year_cool[i][mb] = Math.round(last_year_cool[i][mb] * 10) / 10
                    last_year_energy[i][mb] = Math.round(last_year_energy[i][mb] * 10) / 10
                }

            }

// for each airco calculate the totals and round the numbers to 1 decimal

            for ( var ii = 0 ; ii < 12 ; ii++ ) {

                last_year_energy[i][12] = last_year_energy[i][12] + last_year_energy[i][ii] ;
                last_year_energy[i][12] = Math.round(last_year_energy[i][12] * 10) / 10

            }

// add all in last array i when i + 1  == daikinCount which means we have them all

            if ( i + 1 == daikinCount ) {
                for ( var mt = 0 ; mt < 13 ; mt++ ) {
                    for ( var ii = 0 ; ii < daikinCount ; ii++ ) {

                        last_year_energy[4][mt] = last_year_energy[4][mt] + last_year_energy[ii][mt]
                        last_year_energy[4][mt] = Math.round(last_year_energy[4][mt] * 10) / 10

                    }
                }
            }
        }
    }
}
