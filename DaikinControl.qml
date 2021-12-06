import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
    id: root
    screenTitle: qsTr("Daikin '" + selectedDaikin + "' Control")
//    screenTitleIconUrl: "qrc:/tsc/fan_on.png"

// active daikin
    
    property int ad : 0
    
// I used a rectangles to get everything lined out and 'removed' them afterwards by setting the hight to 0
//  property int rectangleHeight : 200
    property int rectangleHeight : 0
  
    property bool activeMe : false

    property int rectangleWidthV1 : 152
    property int rectangleWidthV2 : 190
  
    property int fieldheightV1 : 28
    property int fieldheightV2 : 35
    
    property int fieldwidthV1 : 140
    property int fieldwidthV2 : 175

    property string    activeColor: "lightgrey"
//    property string    hoverColor: "lightblue"
    property string    hoverColor: "lightgrey"
    property string    selectedColor : "yellow"

    property string selectedDaikin : ""
// Startup, create Exit button, enable timer and refresh data

    onVisibleChanged: {
        if (visible) {
            if (app.daikinCount > 1 ) {
                addCustomTopRightButton("Monitor All")
            } else {
                addCustomTopRightButton("Exit")
            }
            app.daikinTile.monitorLocked = true
            ad = app.daikinTile.ad
            if ( ad > app.daikinCount ) { ad = 0 }
            selectDaikin1Label.buttonText = app.daikinNames[0]
            selectDaikin2Label.buttonText = app.daikinNames[1]
            selectDaikin3Label.buttonText = app.daikinNames[2]
            selectDaikin4Label.buttonText = app.daikinNames[3]
            refreshScreen()
            activeMe = true
        } else {
// during application load all code is compiled and starts executing
// even when screens or tiles are not visible.....
// after loading DainkinControl.qml  activeMe is false so....
// the next if is to avoid an error during startup when daikinTile is not loaded yet
            if(activeMe) {
                activeMe = false
                app.daikinTile.ad = ad
            }
        }
    }

    onCustomButtonClicked: {
        activeMe = false
        if ( ad == 0) { app.daikinTile.ad = app.daikinCount - 1 } else { app.daikinTile.ad = ad - 1 }
        app.daikinTile.monitorLocked = false
        hide();
    }

// Timer in ms

    Timer {
        id: controlTimer
        interval: 1000;
        running: activeMe
        repeat: true
        onTriggered: refreshScreen()
    }  

    function refreshScreen() {
        
        selectedDaikin = app.daikinNames[ad]
        imgDaikin_Big.source = "file:///qmf/qml/apps/daikin/drawables/" + app.daikinPictures[ad]
        app.readDaikinData(ad)
        powToggle.isSwitchedOn = app.pow;
        stempTempLabel.text = app.homeTemp + "° " + app.directionTemp + " " + app.targetTemp + "°"
    }

    function setTemp(updown) {
// mode auto : 0,1,7 cool : 3 heat : 4 
        var tempmin = 20
        var tempmax = 20
        switch (app.mode) {
        case "0":
        case "1":
        case "7":
        case "3":
        case "4":
            if (app.mode == 3) { 
                tempmin = 18 
                tempmax = 33 
            } else if (app.mode == 4) { 
                tempmin = 10
                tempmax = 31
            } else {
                tempmin = 18
                tempmax = 31
            } 
            switch(updown) {
            case "Up":
                var newtemp = parseInt(app.stemp) + 1
                if ( newtemp <= tempmax ) { 
                    stempTempLabel.text = app.homeTemp + "° " + app.directionTemp + " " + newtemp.toString() + "°"
                    app.setDaikinControl(ad, "stemp", newtemp.toString() + ".0" )    
                }
                break;
            case "Down":
                var newtemp = parseInt(app.stemp) - 1
                if ( newtemp >= tempmin ) { 
                    stempTempLabel.text = app.homeTemp + "° " + app.directionTemp + " " + newtemp.toString() + "°"
                    app.setDaikinControl(ad, "stemp", newtemp.toString() + ".0" )    
                }
                break;
            }
        }
    }

    function selectDaikin(index) {
        ad = index
//        app.ad = index
//        app.daikinTile.ad = index
    }

// --------------------------------------------------- background

    Image {
        id: imgDaikin_Big
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom : settingsButton.top
          }        
        source: "file:///qmf/qml/apps/daikin/drawables/daikin1.png"
    }

// --------------------------------------------------- Rectangles

    Rectangle {
        id: rectangle1
        width:   isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "white"
        anchors {
            right : rectangle2.left
            top: parent.top
        }
        
// ---- Power Button

        Text {
            id: powText
            text: "Power"
            anchors {
                horizontalCenter: rectangle1.horizontalCenter
                top: rectangle1.top
                topMargin: isNxt ? 20 : 16
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#ff0000"
        }
        
        OnOffToggle {
            id: powToggle
            height: 36
            anchors {
                horizontalCenter: rectangle1.horizontalCenter
                top: powText.bottom
                topMargin: isNxt ? 20 : 16
            }
            leftIsSwitchedOn: false
            onSelectedChangedByUser: {
                app.pow = isSwitchedOn
                if (app.pow) {
                    app.setDaikinControl(ad, "pow","1")
                } else {
                    app.setDaikinControl(ad, "pow","0")
                }
            }
        }

// ---- Temperature control

        Text {
            id: tempText
            text: "Temperature"
            anchors {
                horizontalCenter: rectangle1.horizontalCenter
                top: powToggle.bottom
                topMargin: isNxt ? 20 : 16
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#993399"
        }

// ---- Set Temperature Buttons

        YaLabel {
            id: editstempTempUpButton
            buttonText:  "+"
            height: isNxt ? 50 : 40
            width: isNxt ? 80 : 64;  
            buttonActiveColor: "grey"
            buttonHoverColor: hoverColor
            enabled : true
            textColor : "black"
            pixelsizeoverride : true
            pixelsizeoverridesize : isNxt ? 50 : 40
            anchors {
                top: tempText.bottom
                horizontalCenter: rectangle1.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                setTemp("Up")
            }
        }

        Text {
            id: stempTempLabel
            anchors {
                horizontalCenter: rectangle1.horizontalCenter
                top: editstempTempUpButton.bottom
                topMargin: isNxt ? 5 : 4
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#993399"
        }

        YaLabel {
            id: editstempTempDownButton
            buttonText:  "-"
            height: isNxt ? 50 : 40
            width: isNxt ? 80 : 64;  
            buttonActiveColor: "grey"
            buttonHoverColor: hoverColor
            enabled : true
            pixelsizeoverride : true
            pixelsizeoverridesize : isNxt ? 50 : 40
            textColor : "black"    
            anchors {
                top: stempTempLabel.bottom
                horizontalCenter: rectangle1.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                setTemp("Down")
            }
        }

    }

// --------------------------------------------------- Mode Buttons

    Rectangle {
        id: rectangle2
        width:   isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "lightgrey"
        anchors {
            right : rectangle3.left
            top: parent.top
        }

        Text {
            id: colum1HeaderText
            text: "Mode"
            anchors {
                horizontalCenter: rectangle2.horizontalCenter
                top: parent.top
                topMargin: isNxt ? 20 : 16
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#993399"
        }

        YaLabel {
            id: modeAutoLabel
            buttonText:  "Auto"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( (app.mode == "0") || (app.mode == "1") || (app.mode == "7") ) ? true : false
            textColor : "black"
            anchors {
                horizontalCenter: rectangle2.horizontalCenter
                top: colum1HeaderText.bottom
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "mode", "0" )    
            }
        }

        YaLabel {
            id: modeCoolLabel
            buttonText:  "Cool"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : (app.mode == "3") ? true : false
            textColor : "black"
            anchors {
                top: modeAutoLabel.bottom
                horizontalCenter: rectangle2.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "mode", "3" )    
            }
        }

        YaLabel {
            id: modeHeatLabel
            buttonText:  "Heat"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : (app.mode == "4")  ? true : false
            textColor : "black"
            anchors {
                top: modeCoolLabel.bottom
                horizontalCenter: rectangle2.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "mode", "4" )    
            }
        }

        YaLabel {
            id: modeVentLabel
            buttonText:  "Vent"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : (app.mode == "6") ? true : false
            textColor : "black"
            anchors {
                top: modeHeatLabel.bottom
                horizontalCenter: rectangle2.horizontalCenter
                topMargin: isNxt ? 5 : 4
                }
            onClicked: {
                app.setDaikinControl(ad, "mode", "6" )    
            }
        }

        YaLabel {
            id: modeDryLabel
            buttonText:  "Dry"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : (app.mode == "2") ? true : false
            textColor : "black"
            anchors {
                top: modeVentLabel.bottom
                horizontalCenter: rectangle2.horizontalCenter
                topMargin: isNxt ? 5 : 4
                }
            onClicked: {
                app.setDaikinControl(ad, "mode", "2" )    
            }
        }

    }

// --------------------------------------------------- Force Buttons

    Rectangle {
        id: rectangle3
        width:   isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "white"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        Text {
            id: colum2HeaderText
            text: "Force"
            anchors {
                horizontalCenter: rectangle3.horizontalCenter
                top: rectangle3.top
                topMargin: isNxt ? 20 : 16
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#993399"
        }

        YaLabel {
            id: f_rateAutoLabel
            buttonText:  "Auto"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "A") ? true : false
            textColor : "black"
            anchors {
                top: colum2HeaderText.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "A" )    
            }
        }

        YaLabel {
            id: f_rateEcoLabel
            buttonText:  "Eco"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "B") ? true : false
            textColor : "black"
            anchors {
                top: f_rateAutoLabel.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "B" )    
            }
        }

        YaLabel {
            id: f_rate1Label
            buttonText:  "1"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "3") ? true : false
            textColor : "black"
            anchors {
                top: f_rateEcoLabel.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "3" )    
            }
        }


        YaLabel {
            id: f_rate2Label
            buttonText:  "2"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "4") ? true : false
            textColor : "black"
            anchors {
                top: f_rate1Label.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "4" )    
            }
        }

        YaLabel {
            id: f_rate3Label
            buttonText:  "3"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "5") ? true : false
            textColor : "black"
            anchors {
                top: f_rate2Label.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "5" )    
            }
        }
        
        YaLabel {
            id: f_rate4Label
            buttonText:  "4"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "6") ? true : false
            textColor : "black"
            anchors {
                top: f_rate3Label.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "6" )    
            }
        }
        
        YaLabel {
            id: f_rate5Label
            buttonText:  "5"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_rate == "7") ? true : false
            textColor : "black"
            anchors {
                top: f_rate4Label.bottom
                horizontalCenter: rectangle3.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
// A : Auto , B : ECO, 3 : lvl_1, 4: lvl_2 etc
                app.setDaikinControl(ad, "f_rate", "7" )    
            }
        }

    }

// --------------------------------------------------- Flow Direction Buttons

    Rectangle {
        id: rectangle4
        width:   isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "lightgrey"
        anchors {
            left : rectangle3.right
            top: parent.top
        }

        Text {
            id: colum3HeaderText
            text: "Flow"
            anchors {
                horizontalCenter: rectangle4.horizontalCenter
                top: rectangle4.top
                topMargin: isNxt ? 20 : 16
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#993399"
        }

        YaLabel {
            id: f_dirOffLabel
            buttonText:  "Off"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_dir == "0") ? true : false
            textColor : "black"
            anchors {
                top: colum3HeaderText.bottom
                horizontalCenter: rectangle4.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "f_dir", "0" )    
            }
        }

        YaLabel {
            id: f_dirVertLabel
            buttonText:  "Vert"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_dir == "1") ? true : false
            textColor : "black"
            anchors {
                top: f_dirOffLabel.bottom
                horizontalCenter: rectangle4.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "f_dir", "1" )    
            }
        }


        YaLabel {
            id: f_dirHorLabel
            buttonText:  "Hor"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_dir == "2") ? true : false
            textColor : "black"
            anchors {
                top: f_dirVertLabel.bottom
                horizontalCenter: rectangle4.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "f_dir", "2" )    
            }
        }


        YaLabel {
            id: f_dir3DLabel
            buttonText:  "Vert + Hor"
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( app.f_dir == "3") ? true : false
            textColor : "black"
            anchors {
                top: f_dirHorLabel.bottom
                horizontalCenter: rectangle4.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                app.setDaikinControl(ad, "f_dir", "3" )    
            }
        }

    }

// --------------------------------------------------- Airco Select Buttons

    Rectangle {
        id: rectangle5
        width:   isNxt ? rectangleWidthV2 : rectangleWidthV1
        height: rectangleHeight
        color: "white"
        anchors {
            left : rectangle4.right
            top: parent.top
        }

        Text {
            id: colum5HeaderText
            text: "Airco"
            anchors {
                top:  rectangle5.top
                topMargin: isNxt ? 20 : 16
                horizontalCenter: rectangle5.horizontalCenter
            }
            font {
                pixelSize: isNxt ? 25 : 20
                family: qfont.bold.name
            }
            color: "#993399"
            visible : (app.daikinCount > 1 )
        }

        YaLabel {
            id: selectDaikin1Label
            buttonText: app.daikinNames[0]
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( ad == "0") ? true : false
            textColor : "black"
            anchors {
                top: colum5HeaderText.bottom
                horizontalCenter: rectangle5.horizontalCenter
                topMargin: isNxt ? 5 : 4
            }
            onClicked: {
                selectDaikin(0)    
            }
            visible : (app.daikinCount > 1 )

        }

        YaLabel {
            id: selectDaikin2Label
            buttonText: app.daikinNames[1]
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( ad == "1") ? true : false
            textColor : "black"
            anchors {
                top: selectDaikin1Label.bottom
                horizontalCenter: rectangle5.horizontalCenter
                topMargin: (app.daikinCount > 1 ) ? ( isNxt ? 5 : 4 ) : 1000
            }
            onClicked: {
                selectDaikin(1)
            }
            visible : (app.daikinCount > 1 )
        }

        YaLabel {
            id: selectDaikin3Label
            buttonText: app.daikinNames[2]
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( ad == "2") ? true : false
            textColor : "black"
            anchors {
                top: selectDaikin2Label.bottom
                horizontalCenter: rectangle5.horizontalCenter
                topMargin: (app.daikinCount > 2 ) ? ( isNxt ? 5 : 4 ) : 1000
            }
            onClicked: {
                selectDaikin(2)
            }
            visible : (app.daikinCount > 2 )
        }

        YaLabel {
            id: selectDaikin4Label
            buttonText: app.daikinNames[3]
            height: isNxt ? fieldheightV2 : fieldheightV1
            width: isNxt ? fieldwidthV2 : fieldwidthV1
            buttonActiveColor: activeColor
            buttonHoverColor: hoverColor
            buttonSelectedColor : selectedColor
            hoveringEnabled : false
            enabled : true
            selected : ( ad == "3") ? true : false
            textColor : "black"
            anchors {
                top: selectDaikin3Label.bottom
                horizontalCenter: rectangle5.horizontalCenter
                topMargin: (app.daikinCount > 3 ) ? ( isNxt ? 5 : 4 ) : 1000
            }
            onClicked: {
                selectDaikin(3)
            }
            visible : (app.daikinCount > 3 )
        }

    }

// --------------------------------------------------- Settings Button

    YaLabel {
        id: settingsButton
        buttonText:  "Settings"
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: hoverColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        buttonBorderWidth: 2
        anchors {
            bottom : parent.bottom
            horizontalCenter: rectangle1.horizontalCenter
            bottomMargin: isNxt ? 15 : 12
        }
        onClicked: {
            activeMe = false
            app.daikinTile.ad = ad
            stage.openFullscreen(app.menuScreenUrl);
        }
    }

// --------------------------------------------------- Energy Button

    YaLabel {
        id: energyButton
        buttonText:  "Usage"
        height: isNxt ? fieldheightV2 : fieldheightV1
        width: isNxt ? fieldwidthV2 : fieldwidthV1
        buttonActiveColor: hoverColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        buttonBorderWidth: 2
        anchors {
            bottom : parent.bottom
            horizontalCenter: rectangle5.horizontalCenter
            bottomMargin: isNxt ? 15 : 12
        }
        onClicked: {
            activeMe = false
            app.daikinTile.ad = ad
            stage.openFullscreen(app.daikinEnergyUrl);
        }
    }

// --------------------------------------------------- bottom line

// Message about leaving to Tile

    Text {
        id: exitMessage
        text: (app.daikinCount > 1 ) ? "Home button to focus on '" + selectedDaikin + "' or upper right to monitor all." : ""
        anchors {
            top: settingsButton.top
            topMargin: 5
            horizontalCenter: rectangle3.horizontalCenter
        }
        font {
            pixelSize: isNxt ? 15 : 12
            family: qfont.bold.name
        }
        color: "#ff00f4"
    }

}
