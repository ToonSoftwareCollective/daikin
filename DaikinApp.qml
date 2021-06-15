import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {

// testReports true generates test values for report and graphs.

    property bool testReports : false
    
    property bool activeMe : false

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

    property string daikinTileColor : "#ffffff"
    property string daikinTileTextColor : "#ffffff"

// data saved in user settings file

    property string interval
    property bool showCountDown;
//    property string daikinName

// data on max 4 daikins

    property int     daikinCount
    property variant daikinNames : []
    property variant daikinIPs : []
    property variant daikinPorts : []

// error count mechanism max 8 errors, retry after 600 seconds

    property variant daikinComErrors : []
    property int maxErrors : 10
    property int resetErrorsTime : 600
    property int daikinErrorsTile : 0

// The next is in the config already but not in use
// The idea is to use a configurable background picture for each airco

    property variant daikinPictures : []

    property variant curr_year_heat : []
    property variant prev_year_heat : []
    property variant curr_year_cool : []
    property variant prev_year_cool : []

    property variant last_year_heat : []
    property variant last_year_cool : []
    property variant last_year_energy : []
    
// update counter

    property int counter

// ....Tile variables

    property bool powTile
    property string daikinNameTile
    property string homeTempTile
    property string roofTempTile
    property string targetTempTile
    property string directionTempTile
    property string modeTile

    property bool monitorLocked : false

// active daikin

    property int     ad

// variable to receive data from Daikin

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

    property string homeTemp
    property string roofTemp
    property string targetTemp
    property string directionTemp

// control set variables received

    property bool pow
    property string mode
    property string stemp
    property string shum
    property string f_rate
    property string f_dir

// control set variable values to send back (from received reference data per mode)

    property string modevalue
    property string stempvalue
    property string shumvalue
    property string f_ratevalue
    property string f_dirvalue

// ---------- Location of user settings file

    FileIO {
        id: userSettingsFile
        source: "file:///mnt/data/tsc/daikin.userSettings.json"
     }

// ---------- Structure user settings from settings file

    property variant userSettingsJSON : {}

// ---------- Load APP requirements

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

// ---------- Actions right after APP startup

    Component.onCompleted: {

// read user settings

        try {
            userSettingsJSON = JSON.parse(userSettingsFile.read());

            interval        = userSettingsJSON['interval'];
            showCountDown   = (userSettingsJSON['ShowCountDown'] == "yes") ? true : false
            daikinCount     = userSettingsJSON['daikinCount'];
            daikinNames     = userSettingsJSON['daikinNames'].slice()
            daikinIPs       = userSettingsJSON['daikinIPs'].slice()
            daikinPorts     = userSettingsJSON['daikinPorts'].slice()
            daikinPictures  = userSettingsJSON['daikinPictures'].slice()

        } catch(e) {

            interval        = "5"
            showCountDown   = false
            daikinCount     = 4
            daikinNames     = ["click me and........","click......................","settings...............","to configure........"]
            daikinIPs       = ["","","",""]
            daikinPorts     = ["80","80","80","80"]
            daikinPictures  = ["daikin1.png","daikin2.png","daikin3.png","daikin4.png"]

        }

// prepare for running

        daikinComErrors = [0,0,0,0]
        
        for ( var i = 0 ; i < 4 ; i++) {
            curr_year_heat[i] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
            prev_year_heat[i] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
            curr_year_cool[i] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
            prev_year_cool[i] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        }

        counter = 0
        ad = -1
        readDaikinData(ad)

    }

// ---------- Save user settings

    function saveSettings(){

         var tmpUserSettingsJSON = {
            "interval":         interval,
            "daikinCount":      daikinCount,
            "daikinNames":      daikinNames,
            "daikinIPs":        daikinIPs,
            "daikinPorts":      daikinPorts,
            "daikinPictures":   daikinPictures,
            "ShowCountDown":    (showCountDown) ? "yes" : "no"
        }
        var doc3 = new XMLHttpRequest();
        doc3.open("PUT", "file:///mnt/data/tsc/daikin.userSettings.json");
        doc3.send(JSON.stringify(tmpUserSettingsJSON));
    }

// ---------- Get Daikin data

    function readDaikinData(di)  {

// di :: daikin index 0..4

        var ipAddress = daikinIPs[di]
        var httpPort = daikinPorts[di]

        var connectionPath = ipAddress + ":" + httpPort;

        if ( connectionPath.length > 4 ) {

// get sensor info

            var xmlhttpSensor = new XMLHttpRequest();

            xmlhttpSensor.open("GET", "http://"+connectionPath+"/aircon/get_sensor_info", false);

            xmlhttpSensor.onreadystatechange = function() {

                if (xmlhttpSensor.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpSensor.status === 200) {

                        daikinSensorData = '{"' + xmlhttpSensor.response.split('=').join('":"').split(',').join('","') + '"}';

                        dataSensorJSON = JSON.parse(daikinSensorData);

                        var newhomeTemp = dataSensorJSON['htemp'].slice(0, -2)

                        var newroofTemp = dataSensorJSON['otemp'].slice(0, -2)

// Variables for Tile have Tile in them -> possibility to act different on Tile

                        homeTempTile = newhomeTemp

                        if ( newroofTemp.length > 0 ) {
                            roofTempTile = newroofTemp
                        }

                        homeTemp = newhomeTemp

                        daikinComErrors[di] = 0
                    } else {
                        daikinComErrors[di] = daikinComErrors[di] + 1
                        if ( daikinComErrors[di] >= maxErrors ) { daikinComErrors[di] = resetErrorsTime }
                        saveJSON("http://"+connectionPath+"/aircon/get_sensor_info Return status: " + xmlhttpSensor.status,"xmlhttpSensorerrorRead")
                        homeTempTile =  "check";
                        directionTempTile = ""
                        targetTempTile =  "cfg";
                        roofTempTile =  "";
                    }
                }
            }
            xmlhttpSensor.send();

// get control info

            var xmlhttpControl = new XMLHttpRequest();

            xmlhttpControl.open("GET", "http://"+connectionPath+"/aircon/get_control_info", false);

            xmlhttpControl.onreadystatechange = function() {

                if (xmlhttpControl.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpControl.status === 200) {

                        daikinControlData = '{"' + xmlhttpControl.response.split('=').join('":"').split(',').join('","') + '"}';

                        dataControlJSON = JSON.parse(daikinControlData);

// Variables for Tile have Tile in them -> possibility to act different on Tile

                        switch (dataControlJSON['mode']) {
                        case "0":
                        case "1":
                        case "7":
                            directionTempTile = ">"
                            targetTempTile = dataControlJSON['stemp'].slice(0, -2);
                            directionTemp = ">"
                            targetTemp = dataControlJSON['stemp'].slice(0, -2);
                            break;
                        case "2":
                            directionTempTile = "="
                            targetTempTile = "nvt";
                            targetTempTile = homeTempTile;
                            directionTemp = "="
                            targetTemp = "nvt";
                            targetTemp = homeTemp;
                            break;
                        case "3":
                            directionTempTile = "v"
                            targetTempTile = dataControlJSON['stemp'].slice(0, -2);
                            directionTemp = "v"
                            targetTemp = dataControlJSON['stemp'].slice(0, -2);
                            break;
                        case "4":
                            directionTempTile = "^"
                            targetTempTile = dataControlJSON['stemp'].slice(0, -2);
                            directionTemp = "^"
                            targetTemp = dataControlJSON['stemp'].slice(0, -2);
                            break;
                        case "6":
                            directionTempTile = "="
                            targetTempTile = "nvt";
                            targetTempTile = homeTempTile;
                            directionTemp = "="
                            targetTemp = "nvt";
                            targetTemp = homeTemp;
                            break;
                        }

                        powTile = (dataControlJSON['pow'] == "1") ? true : false
                        modeTile = dataControlJSON['mode']

                        pow = (dataControlJSON['pow'] == "1") ? true : false
                        mode = dataControlJSON['mode']
                        f_rate = dataControlJSON['f_rate']
                        f_dir = dataControlJSON['f_dir']
                        stemp = dataControlJSON['stemp']
                        shum = dataControlJSON['shum']

                        daikinComErrors[di] = 0
                    } else {
                        daikinComErrors[di] = daikinComErrors[di] + 1
                        if ( daikinComErrors[di] >= maxErrors ) { daikinComErrors[di] = resetErrorsTime }
                        saveJSON("http://"+connectionPath+"/aircon/get_control_info Return status: " + xmlhttpControl.status,"xmlhttpGETControlerrorRead")
                        homeTempTile =  "check";
                        directionTempTile = ""
                        targetTempTile =  "cfg";
                        roofTempTile =  "";
                    }
                }
            }

            xmlhttpControl.send();

            xmlhttpSensor = null
            xmlhttpControl = null

        } else {
            daikinComErrors[di] = 0
            homeTempTile =  "check";
            directionTempTile = ""
            targetTempTile =  "cfg";
            roofTempTile =  "";
        }
    }


// ---------- Set Daikin Control

    function setDaikinControl(di, which, value)  {

// di       :: daikin index 0..4
// which    :: setting to change
// value    :: value for the setting

        var ipAddress = daikinIPs[di]
        var httpPort = daikinPorts[di]

        var connectionPath = ipAddress + ":" + httpPort;

        if ( connectionPath.length > 4 ) {

// get control info

            var xmlhttpSetControlGet = new XMLHttpRequest();

            xmlhttpSetControlGet.open("GET", "http://"+connectionPath+"/aircon/get_control_info", false);

            xmlhttpSetControlGet.onreadystatechange = function() {

                if (xmlhttpSetControlGet.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpSetControlGet.status === 200) {

                        daikinSetControlData = xmlhttpSetControlGet.response;

                        dataSetControlJSON = JSON.parse('{"' + xmlhttpSetControlGet.response.split('=').join('":"').split(',').join('","') + '"}');

                        daikinComErrors[di] = 0
                    } else {
                        daikinComErrors[di] = daikinComErrors[di] + 1
                        if ( daikinComErrors[di] >= maxErrors ) { daikinComErrors[di] = resetErrorsTime }
                        saveJSON("http://"+connectionPath+"/aircon/get_control_info Return status: " + xmlhttpSetControlGet.status,"xmlhttpGETControlerrorSet")
                        homeTempTile =  "check";
                        directionTempTile = ""
                        targetTempTile =  "cfg";
                        roofTempTile =  "";
                    }
                }
            }

            xmlhttpSetControlGet.send();

            var newControls = {}

            newControls['pow'] = dataSetControlJSON['pow']
            newControls['f_rate'] = dataSetControlJSON['f_rate']
            newControls['f_dir'] = dataSetControlJSON['f_dir']
            newControls['stemp'] = dataSetControlJSON['stemp']
            newControls['shum'] = dataSetControlJSON['shum']
            newControls['mode'] = dataSetControlJSON['mode']

// ------ simplified

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

            xmlhttpSetControlSet.open("GET", "http://"+connectionPath+"/aircon/set_control_info?" + daikinSetControlData , false);

              xmlhttpSetControlSet.onreadystatechange = function() {

                  if (xmlhttpSetControlSet.readyState == XMLHttpRequest.DONE) {

                      if (xmlhttpSetControlSet.status === 200) {

                        daikinSetControlData = xmlhttpSetControlSet.response;

                        daikinComErrors[di] = 0
                      } else {
                        daikinComErrors[di] = daikinComErrors[di] + 1
                        if ( daikinComErrors[di] >= maxErrors ) { daikinComErrors[di] = resetErrorsTime }
                        saveJSON("http://"+connectionPath+"/aircon/set_control_info?" + daikinSetControlData + " Return status: " + xmlhttpSetControlSet.status,"xmlhttpControlerrorSet")
                        homeTempTile =  "check";
                        directionTempTile = ""
                        targetTempTile =  "cfg";
                        roofTempTile =  "";
                      }
                  }
              }

            xmlhttpSetControlSet.send();

            xmlhttpSetControlGet = null
            xmlhttpSetControlSet = null

        } else {
            daikinComErrors[di] = 0
            homeTempTile =  "check";
            directionTempTile = ""
            targetTempTile =  "cfg";
            roofTempTile =  "";
        }
    }

// ---------- Get Daikin Energy
    
    function readDaikinEnergy(di)  {

        curr_year_heat[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        prev_year_heat[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        curr_year_cool[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        prev_year_cool[di] = [0,0,0,0,0,0,0,0,0,0,0,0,0]

// di :: daikin index 0..4

        var ipAddress = daikinIPs[di]
        var httpPort = daikinPorts[di]

        var connectionPath = ipAddress + ":" + httpPort;

        if ( testReports ) {

            for ( var i = 0 ; i < 13 ; i++ ) {
                curr_year_heat[di][i] = Math.round((di + 1) * (i + 1) * Math.random())
                prev_year_heat[di][i] = Math.round((di + 1) * (i + 1) * Math.random())
                curr_year_cool[di][i] = Math.round((di + 1) * (i + 1) * Math.random())
                prev_year_cool[di][i] = Math.round((di + 1) * (i + 1) * Math.random())
            }
            
        } else if ( ( connectionPath.length > 4 ) && ( daikinComErrors[ad] < maxErrors) ) {

// get sensor info

            var xmlhttpEnergy = new XMLHttpRequest();

            xmlhttpEnergy.open("GET", "http://"+connectionPath+"/aircon/get_year_power_ex", false);

            xmlhttpEnergy.onreadystatechange = function() {

                if (xmlhttpEnergy.readyState == XMLHttpRequest.DONE) {

                    if (xmlhttpEnergy.status === 200) {

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
                        daikinComErrors[di] = 0
                    } else {
                        daikinComErrors[di] = daikinComErrors[di] + 1
                        if ( daikinComErrors[di] >= maxErrors ) { daikinComErrors[di] = resetErrorsTime }
                        saveJSON("http://"+connectionPath+"/aircon/get_year_power_ex Return status: " + xmlhttpEnergy.status,"xmlhttpEnergyerror")
                    }
                }
            }

            xmlhttpEnergy.send();

            xmlhttpEnergy = null

        }
        
    }

// ---------- calculateEnergy 

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

// ---------- save json data in json file. Used for debugging.

    function saveJSON(text,id) {

          var doc3 = new XMLHttpRequest();
           doc3.open("PUT", "file:///var/volatile/tmp/daikin_retrieved_data_"+id+".json");
           doc3.send(text);
    }

// ---------- Timer and timer action

// Timer in ms

    Timer {
        id: appTimer
        interval: 1000;
        running: activeMe
        repeat: true
        onTriggered: refreshScreen()
    }

// color codes below from https://www.color-hex.com/

    function refreshScreen() {

        if ( counter >  0 ) {
            counter = counter - 1
        } else {
            counter = interval - 1

            if ( ! monitorLocked ) {
                ad = ( ad + 1 ) % daikinCount
            }
        }

        if ( daikinComErrors[ad] > maxErrors ) {

// substract 1 for for every second passed and take number of daikins into account

            if ( counter == interval - 1 ) { daikinComErrors[ad] = daikinComErrors[ad] - ( daikinCount - 1 ) * interval }

            daikinComErrors[ad] = daikinComErrors[ad] - 1

// in case of a long interval this value may become < 0

            if (daikinComErrors[ad] < 0) { daikinComErrors[ad] = 0}

            homeTempTile =  "wait";
            directionTempTile = ""
            targetTempTile =  "......";
            roofTempTile =  "";

            daikinNameTile = daikinNames[ad]

        } else {

            daikinNameTile = daikinNames[ad]

            if ( counter == interval - 1 ) {readDaikinData(ad) }

        }

        daikinErrorsTile = daikinComErrors[ad]
        if (daikinComErrors[ad] > 0) { powTile = false }

        if (powTile) {
            switch (modeTile) {
                case "0":
                case "1":
                case "7":
// mode auto purple
                    daikinTileColor = "#ff00f4"
                    daikinTileTextColor = "#000000"
                    break;
                case "2":
// mode dry green
                    daikinTileColor = "#00ff40"
                    daikinTileTextColor = "#000000"
                    break;
                case "3":
// mode cool blue ok
                    daikinTileColor = "#00f4ff"
                    daikinTileTextColor = "#000000"
                    break;
                case "4":
// mode heat red
                    daikinTileColor = "#ff0000"
                    daikinTileTextColor = "#ffffff"
                    break;
                case "6":
// mode ventilate yellow ok
                    daikinTileColor = "#fff400"
                    daikinTileTextColor = "#000000"
                    break;
            }
        }
    }

}
