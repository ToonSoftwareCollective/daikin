import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
    id: root
    screenTitle: qsTr("Daikin Settings")

// I used a rectangles to get everything lined out and 'removed' them afterwards by setting the hight to 0
//    property int rectangleHeight : 200
    property int rectangleHeight : 0

    property int rectangleWidthV1 : 152
    property int rectangleWidthV2 : 190
  
    property int fieldheightV1 : 28
    property int fieldheightV2 : 35
    
    property int fieldwidthV1 : 140
    property int fieldwidthV2 : 175

    property string    activeColor: "lightblue"
    property string    hoverColor: "darkblue"
    property string    selectedColor : "yellow"
  
    Image {
        id: imgDaikin_Big
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: pictureMessage.top
        }
        source: "file:///qmf/qml/apps/daikin/drawables/daikinSettings.png"
    }
    
// On startup create Save button and put values in form

    onShown: {
        addCustomTopRightButton("Save");
 
        daikinName1.buttonText = app.daikinNames[0];
        daikinIP1.buttonText = app.daikinIPs[0];
        daikinPort1.buttonText = app.daikinPorts[0];
 
        daikinName2.buttonText = app.daikinNames[1];
        daikinIP2.buttonText = app.daikinIPs[1];
        daikinPort2.buttonText = app.daikinPorts[1];
 
        daikinName3.buttonText = app.daikinNames[2];
        daikinIP3.buttonText = app.daikinIPs[2];
        daikinPort3.buttonText = app.daikinPorts[2];
 
        daikinName4.buttonText = app.daikinNames[3];
        daikinIP4.buttonText = app.daikinIPs[3];
        daikinPort4.buttonText = app.daikinPorts[3];

        aircoCountValue.buttonText = app.daikinCount
 
        intervalValue.buttonText = app.interval;

        if ( app.showCountDown == true ) {
            showCountDownToggle.buttonText = "Show Countdown"
        } else {
            showCountDownToggle.buttonText = "No Countdown"
        }
    }

    onCustomButtonClicked: {
        app.saveSettings();
        hide();
    }

// -------------------------------------------------- daikin 1 functions

    function savedaikinName1(text) {
        if (text) {
            daikinName1.buttonText = text.trim();
            app.daikinNames[0] = text.trim();
        }
    }

    function savedaikinIP1(text) {
        if (text) {
            if (( text.trim() == "" ) || (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(text)) ) {  
                daikinIP1.buttonText = text.trim();
                app.daikinIPs[0] = text.trim();
            }
        }
    }

    function savedaikinPort1(text) {
        if (text) {
            if ( parseInt(text) > 0 ) {
                daikinPort1.buttonText = text.trim();
                app.daikinPorts[0] = text.trim();
            }
        }
    }

// -------------------------------------------------- daikin 2 functions

    function savedaikinName2(text) {
        if (text) {
            daikinName2.buttonText = text.trim();
            app.daikinNames[1] = text.trim();
        }
    }

    function savedaikinIP2(text) {
        if (text) {
            if (( text.trim() == "" ) || (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(text)) ) {  
                daikinIP2.buttonText = text.trim();
                app.daikinIPs[1] = text.trim();
            }
        }
    }

    function savedaikinPort2(text) {
        if (text) {
            if ( parseInt(text) > 0 ) {
                daikinPort2.buttonText = text.trim();
                app.daikinPorts[1] = text.trim();
            }
        }
    }

// -------------------------------------------------- daikin 3 functions

    function savedaikinName3(text) {
        if (text) {
            daikinName3.buttonText = text.trim();
            app.daikinNames[2] = text.trim();
        }
    }

    function savedaikinIP3(text) {
        if (text) {
            if (( text.trim() == "" ) || (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(text)) ) {  
                daikinIP3.buttonText = text.trim();
                app.daikinIPs[2] = text.trim();
            }
        }
    }

    function savedaikinPort3(text) {
        if (text) {
            if ( parseInt(text) > 0 ) {
                daikinPort3.buttonText = text.trim();
                app.daikinPorts[2] = text.trim();
            }
        }
    }

// -------------------------------------------------- daikin 4 functions

    function savedaikinName4(text) {
        if (text) {
            daikinName4.buttonText = text.trim();
            app.daikinNames[3] = text.trim();
        }
    }

    function savedaikinIP4(text) {
        if (text) {
            if (( text.trim() == "" ) || (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(text)) ) {  
                daikinIP4.buttonText = text.trim();
                app.daikinIPs[3] = text.trim();
            }
        }
    }

    function savedaikinPort4(text) {
        if (text) {
            if ( parseInt(text) > 0 ) {
                daikinPort4.buttonText = text.trim();
                app.daikinPorts[3] = text.trim();
            }
        }
    }

// -------------------------------------------------- column 5 functions

    function saveInterval(text) {
        if (text) {
            if ( parseInt(text) >= 5 ) {
                intervalValue.buttonText = text.trim();
                app.interval = text.trim();
            }
        }
    }

    function saveaircoCount(text) {
        if (text) {
            if ( ( parseInt(text) > 0 ) && ( parseInt(text) < 5 ) ) { 
                aircoCountValue.buttonText = parseInt(text);
                app.daikinCount = parseInt(text);
            }
        
            if ( app.daikinControl.ad  >  ( app.daikinCount - 1 ) ) {
                app.daikinControl.ad = app.daikinCount - 1
                app.ad = app.daikinCount - 1
            }

        }
    }

// --------------------------------------------------- Rectangles

    Rectangle {
        id: rectangle1
        width: isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "white"
        anchors {
            right : rectangle2.left
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle2
        width: isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "lightgrey"
        anchors {
            right : rectangle3.left
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle3
        width: isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "white"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle4
        width: isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "lightgrey"
        anchors {
            left : rectangle3.right
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle5
        width: isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "white"
        anchors {
            left : rectangle4.right
            top: parent.top
        }
    }

// --------------------------------------------------- rectangle1

    Text {
        id: daikinNameLabel1
        text: "Name"
        anchors {
            top: rectangle1.top
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle1.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinName1
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinNameLabel1.bottom
            horizontalCenter: rectangle1.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The name for your Daikin airco", daikinName1.buttonText, savedaikinName1)
        }
    }

    Text {
        id: ipLabel1
        text: "IP Address"
        anchors {
            top: daikinName1.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle1.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinIP1
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: ipLabel1.bottom
            horizontalCenter: rectangle1.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The IP address for your " + daikinName1.buttonText + " airco", daikinIP1.buttonText, savedaikinIP1)
        }
    }


    Text {
        id: portLabel1
        text: "TCP port"
        anchors {
            top: daikinIP1.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle1.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }


    YaLabel {
        id: daikinPort1
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: portLabel1.bottom
            horizontalCenter: rectangle1.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The TCP port for your " + daikinName1.buttonText + " airco", daikinPort1.buttonText, savedaikinPort1)
        }
    }

// --------------------------------------------------- rectangle2

    Text {
        id: daikinNameLabel2
        text: "Name"
        anchors {
            top: (app.daikinCount > 1 ) ? rectangle2.top : parent.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle2.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinName2
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinNameLabel2.bottom
            horizontalCenter: rectangle2.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The name for your Daikin airco", daikinName2.buttonText, savedaikinName2)
        }
    }

    Text {
        id: ipLabel2
        text: "IP Address"
        anchors {
            top: daikinName2.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle2.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinIP2
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: ipLabel2.bottom
            horizontalCenter: rectangle2.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The IP address for your " + daikinName2.buttonText + " airco", daikinIP2.buttonText, savedaikinIP2)
        }
    }


    Text {
        id: portLabel2
        text: "TCP port"
        anchors {
            top: daikinIP2.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle2.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }


    YaLabel {
        id: daikinPort2
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: portLabel2.bottom
            horizontalCenter: rectangle2.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The TCP port for your " + daikinName2.buttonText + " airco", daikinPort2.buttonText, savedaikinPort2)
        }
    }

// --------------------------------------------------- rectangle3

    Text {
        id: daikinNameLabel3
        text: "Name"
        anchors {
            top: (app.daikinCount > 2 ) ? rectangle3.top : parent.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle3.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinName3
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinNameLabel3.bottom
            horizontalCenter: rectangle3.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The name for your Daikin airco", daikinName3.buttonText, savedaikinName3)
        }
    }

    Text {
        id: ipLabel3
        text: "IP Address"
        anchors {
            top: daikinName3.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle3.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinIP3
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: ipLabel3.bottom
            horizontalCenter: rectangle3.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The IP address for your " + daikinName3.buttonText + " airco", daikinIP3.buttonText, savedaikinIP3)
        }
    }


    Text {
        id: portLabel3
        text: "TCP port"
        anchors {
            top: daikinIP3.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle3.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }


    YaLabel {
        id: daikinPort3
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: portLabel3.bottom
            horizontalCenter: rectangle3.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The TCP port for your " + daikinName3.buttonText + " airco", daikinPort3.buttonText, savedaikinPort3)
        }
    }


// --------------------------------------------------- rectangle4

    Text {
        id: daikinNameLabel4
        text: "Name"
        anchors {
            top: (app.daikinCount > 3 ) ? rectangle4.top : parent.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle4.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinName4
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinNameLabel4.bottom
            horizontalCenter: rectangle4.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The name for your Daikin airco", daikinName4.buttonText, savedaikinName4)
        }
    }

    Text {
        id: ipLabel4
        text: "IP Address"
        anchors {
            top: daikinName4.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle4.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: daikinIP4
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: ipLabel4.bottom
            horizontalCenter: rectangle4.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The IP address for your " + daikinName4.buttonText + " airco", daikinIP4.buttonText, savedaikinIP4)
        }
    }


    Text {
        id: portLabel4
        text: "TCP port"
        anchors {
            top: daikinIP4.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle4.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }


    YaLabel {
        id: daikinPort4
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: portLabel4.bottom
            horizontalCenter: rectangle4.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The TCP port for your " + daikinName4.buttonText + " airco", daikinPort4.buttonText, savedaikinPort4)
        }
    }

// --------------------------------------------------- rectangle5

    Text {
        id: aircoCountText
        text: "1,2,3 or 4 airco's"
        anchors {
            top: rectangle5.top
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle5.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: aircoCountValue
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: aircoCountText.bottom
            horizontalCenter: rectangle5.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The number of airco's you have, 1,2,3 or 4", aircoCountValue.buttonText, saveaircoCount)
        }
    }

    Text {
        id: intervalText
        text: "Refresh Interval"
        anchors {
            top: aircoCountValue.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle5.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: intervalValue
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: intervalText.bottom
            horizontalCenter: rectangle5.horizontalCenter
        }
        onClicked: {
            qkeyboard.open("The name for your Daikin airco", intervalValue.buttonText, saveInterval)
        }
    }

// Countdown visible toggle

    Text {
        id: countdownText
        text: "Countdown on Tile?"
        anchors {
            top: intervalValue.bottom
            topMargin: isNxt ? 20 : 16
            horizontalCenter: rectangle5.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 20 : 16
            family: qfont.bold.name
        }
    }

    YaLabel {
        id: showCountDownToggle
        buttonText:  ""
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: countdownText.bottom
            horizontalCenter: rectangle5.horizontalCenter
        }
        onClicked: {
            app.showCountDown = ! app.showCountDown
            if ( app.showCountDown == true ) {
                showCountDownToggle.buttonText = "Show Countdown"
            } else {
                showCountDownToggle.buttonText = "No Countdown"
            }
        }
    }

// --------------------------------------------------- bottom line

// Message about picture replacement

    Text {
        id: pictureMessage
//        text: "You may replace the background pictures in the folder '/qmf/qml/apps/daikin/drawables/' with your own."
        text: ""
        anchors {
            bottom: parent.bottom
            bottomMargin: isNxt ? 20 : 16
            horizontalCenter: parent.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 15 : 12
            family: qfont.bold.name
        }
        color: "#ff00f4"
    }

}

