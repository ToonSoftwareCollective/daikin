import QtQuick 2.1
import qb.components 1.0

Tile {
    id : daikinTile

    property bool   activeMe    : false

    property bool   errorState  : false
    
// active daikin

    property int    ad          : -1

// update counter

    property int counter        : 0

// show aircos 1 by 1 or lock on last used in control screen

    property bool monitorLocked : false

    property string daikinNameTile

    property string daikinTileColor : "#ffffff"
    property string daikinTileTextColor : "#ffffff"

    onVisibleChanged : {
        if (visible) {
            counter = 1
            activeMe = true
        } else {
            activeMe = false
        }
    }

/*

// when you have a variable named 'someThing' you can use onSomeThingChanged
// note that the first character of the name changes from lower to upper case
// and that will run when the value of the variable 'someThing' changes
// just like with the variable counter and onCounterChanged below

    onCounterChanged : {
        app.log(counter)
    }
*/

    onClicked : {
        stage.openFullscreen(app.controlScreenUrl);
    }

// Timer in ms

    Timer {
        id : appTimer
        interval : 1000;
        running : activeMe
        repeat : true
        onTriggered : {
            if (counter <= 1 ) { counter = app.update_interval ; refreshScreen() }
            else { counter = ( counter - 1 ) }
        }
    }

// color codes below from https://www.color-hex.com/

    function refreshScreen() {

        if ( ! monitorLocked ) {
            ad = ( ad + 1 ) % app.daikinCount
        }

        daikinNameTile = app.daikinNames[ad]

        app.readDaikinData(ad)

        errorState = app.asynchronous_com[ad]
        
        if (app.pow) {
            switch (app.mode) {
                case "0" :
                case "1" :
                case "7" :
// mode auto purple
                    daikinTileColor = "#ff00f4"
                    daikinTileTextColor = "#000000"
                    break;
                case "2" :
// mode dry green
                    daikinTileColor = "#00ff40"
                    daikinTileTextColor = "#000000"
                    break;
                case "3" :
// mode cool blue ok
                    daikinTileColor = "#00f4ff"
                    daikinTileTextColor = "#000000"
                    break;
                case "4" :
// mode heat red
                    daikinTileColor = "#ff0000"
                    daikinTileTextColor = "#ffffff"
                    break;
                case "6" :
// mode ventilate yellow ok
                    daikinTileColor = "#fff400"
                    daikinTileTextColor = "#000000"
                    break;
            }
        }
    }

    Rectangle {
        id : rectangleAircoInfo
        width : parent.width
        height : parent.height
        color : (app.pow) ?  daikinTileColor : (canvas.dimState) ? "#000000" : "#ffffff"
        radius : 5

        visible : ( ! errorState )

        Text {
            id : tiletitle
            width : parent.width
            text : (app.showCountDown) ? daikinNameTile + " " + counter : daikinNameTile

            horizontalAlignment : Text.AlignHCenter
            anchors {
                baseline : parent.top
                baselineOffset : isNxt ? 30 : 24
            }
            font {
                family : qfont.bold.name
                pixelSize : isNxt ? 25 : 20
            }
            color : (app.pow) ? daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        }

        Text {
            id : line1
            text : app.homeTemp + "° " + app.directionTemp + " " + app.targetTemp + "°"
            color : (app.pow) ? daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors {
                top : tiletitle.bottom
                horizontalCenter : parent.horizontalCenter
            }
            font.pixelSize : isNxt ? 60 : 48
            font.family : qfont.italic.name
            font.bold : true
        }

        Text {
            id : line2
            text : app.roofTemp + "°"
            color : (app.pow) ? daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors {
                bottom : parent.bottom
                horizontalCenter : parent.horizontalCenter
            }
            font.pixelSize : isNxt ? 70 : 56
            font.family : qfont.italic.name
            font.bold : true
        }
    }

    Rectangle {
        id    : rectangleError
        width : parent.width
        height : parent.height
        color : "white"

        visible : ( errorState )

        Text {
            id : error
            text : "Check\nSettings\n"+app.daikinNames[ad]
            color : "red"
            anchors {
                horizontalCenter : parent.horizontalCenter
                verticalCenter : parent.verticalCenter
            }
            font.pixelSize : isNxt ? 25 : 20
            font.family : qfont.italic.name
            font.bold : true
        }
    }
}
