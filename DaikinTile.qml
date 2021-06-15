import QtQuick 2.1
import qb.components 1.0

Tile {
    id: daikinTile
    property bool dimState: screenStateController.dimmedColors
    
    Rectangle {
      width: daikinTile.width
      height: daikinTile.height
      color: (app.powTile) ?  app.daikinTileColor : (canvas.dimState) ? "#000000" : "#ffffff"
      radius: 5
    }

    onVisibleChanged: {
        if (visible) {
            app.activeMe = true
        } else { 
            app.activeMe = false
        }
    }

    onClicked: {
        stage.openFullscreen(app.controlScreenUrl);
    }
    
// Title

    Text {
        id: tiletitle
        width: daikinTile.width
//        text: (app.showCountDown && app.daikinComErrors[app.ad] > 0) ? app.daikinNameTile + " " + app.counter + " " + app.daikinComErrors[app.ad] : (app.showCountDown) ? app.daikinNameTile + " " + app.counter : app.daikinNameTile 
        text: (app.showCountDown && app.daikinErrorsTile > 0) ? app.daikinNameTile + " " + app.counter + " " + app.daikinErrorsTile : (app.daikinErrorsTile > 0) ? app.daikinNameTile + " " + app.daikinErrorsTile : (app.showCountDown) ? app.daikinNameTile + " " + app.counter : app.daikinNameTile 

        horizontalAlignment: Text.AlignHCenter
        anchors {
            baseline: parent.top
            baselineOffset: isNxt ? 30 : 24
        }
        font {
            family: qfont.bold.name
            pixelSize: isNxt ? 25 : 20
        } 
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
    }

// line 1 text

    Text {
        id: tilehomeTemp
        text: app.homeTempTile
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tiletitle.bottom
            right: degree1.left
            rightMargin:  isNxt ? 10 : 8  
        }
        font.pixelSize: isNxt ? 60 : 48
        font.family: qfont.italic.name
        font.bold: true
    }

    Text {
        id: degree1
        text: "o"
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tiletitle.bottom
            right: tiledirectionTemp.left
            leftMargin:  isNxt ? 10 : 8  
        }
        font.pixelSize: isNxt ? 20 : 16
        font.family: qfont.italic.name
        font.bold: true
    }

    Text {
        id: tiledirectionTemp
        text: app.directionTempTile 
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tiletitle.bottom
            horizontalCenter: parent.horizontalCenter
        }
        font.pixelSize: isNxt ? 60 : 48
        font.family: qfont.italic.name
        font.bold: true
    }

    Text {
        id: tiletargetTemp
        text: app.targetTempTile
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tiletitle.bottom
            left: tiledirectionTemp.right
            leftMargin:  isNxt ? 10 : 8  
        }
        font.pixelSize: isNxt ? 60 : 48
        font.family: qfont.italic.name
        font.bold: true
    }

    Text {
        id: degree2
        text: "o"
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tiletitle.bottom
            left: tiletargetTemp.right
            leftMargin:  isNxt ? 10 : 8  
        }
        font.pixelSize: isNxt ? 20 : 16
        font.family: qfont.italic.name
        font.bold: true
    }

// line 2 text

    Text {
        id: tileline21
        text: app.roofTempTile
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tiledirectionTemp.bottom
            topMargin : -5
            right: tiledirectionTemp.right
        }
        font.pixelSize: isNxt ? 70 : 56
        font.family: qfont.italic.name
        font.bold: true
    }

    Text {
        id: degree3
        text: "o"
        color: (app.powTile) ? app.daikinTileTextColor : (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            top: tileline21.top
            left: tileline21.right
            leftMargin:  isNxt ? 10 : 8  
        }
        font.pixelSize: isNxt ? 20 : 16
        font.family: qfont.italic.name
        font.bold: true
    }

}
