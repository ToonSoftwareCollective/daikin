import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

// http://192.168.2.123/aircon/get_year_power_ex
// http://192.168.2.123/aircon/get_week_power_ex

Screen {
    id: root
    screenTitle: qsTr("Energy usage in kWh last 12 months")

// I used a rectangles to get everything lined out and 'removed' them afterwards by setting the hight to 0
//    property int rectangleHeight : 440
    property int rectangleHeight : 0

//    property int rectangleWidth : isNxt ? 170 : 136
    property int rectangleWidth : isNxt ? 160 : 128

    property int fieldheight : isNxt ? 30 : 24
  
    property int fieldwidth : isNxt ? 170 : 136

    property string    activeColor: "lightblue"
    property string    hoverColor: "darkblue"
    property string    selectedColor : "yellow"

    property int currentMonth

    property int rectangle0LeftMargin : 100

    property int daikinIndex
    
// On startup create Save button and put values in form

    onShown: {
        addCustomTopRightButton("Exit");

        switch(app.daikinCount) {

            case 1 : rectangle0LeftMargin = rectangleWidth * 2 ; break ;
            case 2 : rectangle0LeftMargin = rectangleWidth ; break ;
            case 3 : rectangle0LeftMargin = parseInt(rectangleWidth / 2)  ; break ;
            case 4 : rectangle0LeftMargin = 10 ; break ;
        }
        
        var d = new Date();
        currentMonth = d.getMonth() + 1;

        daikinName1.buttonText = app.daikinNames[0];
        app.readDaikinEnergy(0)

        if (app.daikinCount > 1 ) {
            daikinName2.buttonText = app.daikinNames[1];
            app.readDaikinEnergy(1)
        }

        if (app.daikinCount > 2 ) {
            daikinName3.buttonText = app.daikinNames[2];
            app.readDaikinEnergy(2)
        }

        if (app.daikinCount > 3 ) {
            daikinName4.buttonText = app.daikinNames[3];
            app.readDaikinEnergy(3)
        }
        
        app.calculateEnergy()

        daikin1M0.buttonText = app.last_year_energy[0][0]
        daikin1M0.buttonText = app.last_year_energy[0][0]
        daikin1M1.buttonText = app.last_year_energy[0][1]
        daikin1M2.buttonText = app.last_year_energy[0][2]
        daikin1M3.buttonText = app.last_year_energy[0][3]
        daikin1M4.buttonText = app.last_year_energy[0][4]
        daikin1M5.buttonText = app.last_year_energy[0][5]
        daikin1M6.buttonText = app.last_year_energy[0][6]
        daikin1M7.buttonText = app.last_year_energy[0][7]
        daikin1M8.buttonText = app.last_year_energy[0][8]
        daikin1M9.buttonText = app.last_year_energy[0][9]
        daikin1M10.buttonText = app.last_year_energy[0][10]
        daikin1M11.buttonText = app.last_year_energy[0][11]
        daikin1M12.buttonText = app.last_year_energy[0][12]

        daikin2M0.buttonText = app.last_year_energy[1][0]
        daikin2M1.buttonText = app.last_year_energy[1][1]
        daikin2M2.buttonText = app.last_year_energy[1][2]
        daikin2M3.buttonText = app.last_year_energy[1][3]
        daikin2M4.buttonText = app.last_year_energy[1][4]
        daikin2M5.buttonText = app.last_year_energy[1][5]
        daikin2M6.buttonText = app.last_year_energy[1][6]
        daikin2M7.buttonText = app.last_year_energy[1][7]
        daikin2M8.buttonText = app.last_year_energy[1][8]
        daikin2M9.buttonText = app.last_year_energy[1][9]
        daikin2M10.buttonText = app.last_year_energy[1][10]
        daikin2M11.buttonText = app.last_year_energy[1][11]
        daikin2M12.buttonText = app.last_year_energy[1][12]

        daikin3M0.buttonText = app.last_year_energy[2][0]
        daikin3M1.buttonText = app.last_year_energy[2][1]
        daikin3M2.buttonText = app.last_year_energy[2][2]
        daikin3M3.buttonText = app.last_year_energy[2][3]
        daikin3M4.buttonText = app.last_year_energy[2][4]
        daikin3M5.buttonText = app.last_year_energy[2][5]
        daikin3M6.buttonText = app.last_year_energy[2][6]
        daikin3M7.buttonText = app.last_year_energy[2][7]
        daikin3M8.buttonText = app.last_year_energy[2][8]
        daikin3M9.buttonText = app.last_year_energy[2][9]
        daikin3M10.buttonText = app.last_year_energy[2][10]
        daikin3M11.buttonText = app.last_year_energy[2][11]
        daikin3M12.buttonText = app.last_year_energy[2][12]

        daikin4M0.buttonText = app.last_year_energy[3][0]
        daikin4M1.buttonText = app.last_year_energy[3][1]
        daikin4M2.buttonText = app.last_year_energy[3][2]
        daikin4M3.buttonText = app.last_year_energy[3][3]
        daikin4M4.buttonText = app.last_year_energy[3][4]
        daikin4M5.buttonText = app.last_year_energy[3][5]
        daikin4M6.buttonText = app.last_year_energy[3][6]
        daikin4M7.buttonText = app.last_year_energy[3][7]
        daikin4M8.buttonText = app.last_year_energy[3][8]
        daikin4M9.buttonText = app.last_year_energy[3][9]
        daikin4M10.buttonText = app.last_year_energy[3][10]
        daikin4M11.buttonText = app.last_year_energy[3][11]
        daikin4M12.buttonText = app.last_year_energy[3][12]

        daikin5M0.buttonText = app.last_year_energy[4][0]
        daikin5M1.buttonText = app.last_year_energy[4][1]
        daikin5M2.buttonText = app.last_year_energy[4][2]
        daikin5M3.buttonText = app.last_year_energy[4][3]
        daikin5M4.buttonText = app.last_year_energy[4][4]
        daikin5M5.buttonText = app.last_year_energy[4][5]
        daikin5M6.buttonText = app.last_year_energy[4][6]
        daikin5M7.buttonText = app.last_year_energy[4][7]
        daikin5M8.buttonText = app.last_year_energy[4][8]
        daikin5M9.buttonText = app.last_year_energy[4][9]
        daikin5M10.buttonText = app.last_year_energy[4][10]
        daikin5M11.buttonText = app.last_year_energy[4][11]
        daikin5M12.buttonText = app.last_year_energy[4][12]
        
    }

    onCustomButtonClicked: {
        hide();
    }

// --------------------------------------------------- Rectangles

    Rectangle {
        id: rectangle0
        width: rectangleWidth
        height: rectangleHeight
        color: "lightgrey"
        anchors {
//            left : (app.daikinCount > 2 ) ? parent.left : (app.daikinCount == 2 ) ? rectangleWidth : rectangleWidth * 3
            left : parent.left
            leftMargin : rectangle0LeftMargin
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle1
        width: rectangleWidth
        height: rectangleHeight
        color: "white"
        anchors {
            left : rectangle0.right
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle2
        width: rectangleWidth
        height: rectangleHeight
        color: "lightgrey"
        anchors {
            left : rectangle1.right
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle3
        width: rectangleWidth
        height: rectangleHeight
        color: "white"
        anchors {
            left : rectangle2.right
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle4
        width: rectangleWidth
        height: rectangleHeight
        color: "lightgrey"
        anchors {
            left : rectangle3.right
            top: parent.top
        }
    }

    Rectangle {
        id: rectangle5
        width: rectangleWidth
        height: rectangleHeight
        color: "white"
        anchors {
            left : rectangle4.right
            top: parent.top
        }
    }

// --------------------------------------------------- rectangle0

    YaLabel {
        id: daikinM1
        buttonText:  "Januari"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 1 )
        textColor : "black"
        anchors {
            top: daikinName1.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM2
        buttonText:  "Februari"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 2 )
        textColor : "black"
        anchors {
            top: daikinM1.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM3
        buttonText:  "March"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 3 )
        textColor : "black"
        anchors {
            top: daikinM2.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM4
        buttonText:  "April"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 4 )
        textColor : "black"
        anchors {
            top: daikinM3.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM5
        buttonText:  "May"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 5 )
        textColor : "black"
        anchors {
            top: daikinM4.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM6
        buttonText:  "June"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 6 )
        textColor : "black"
        anchors {
            top: daikinM5.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM7
        buttonText:  "July"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 7 )
        textColor : "black"
        anchors {
            top: daikinM6.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM8
        buttonText:  "August"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 8 )
        textColor : "black"
        anchors {
            top: daikinM7.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM9
        buttonText:  "September"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 9 )
        textColor : "black"
        anchors {
            top: daikinM8.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM10
        buttonText:  "October"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 10 )
        textColor : "black"
        anchors {
            top: daikinM9.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM11
        buttonText:  "November"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 11 )
        textColor : "black"
        anchors {
            top: daikinM10.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM12
        buttonText:  "December"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : ( currentMonth == 12 )
        textColor : "black"
        anchors {
            top: daikinM11.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }

    YaLabel {
        id: daikinM13
        buttonText:  "Totals"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinM12.bottom
            horizontalCenter: rectangle0.horizontalCenter
        }
    }


// --------------------------------------------------- rectangle1

    YaLabel {
        id: daikinName1
        buttonText:  ""
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: rectangle1.top
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M0
        buttonText:  "M0"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinName1.bottom
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M1
        buttonText:  "M1"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M0.bottom
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M2
        buttonText:  "M2"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M1.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M3
        buttonText:  "M3"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M2.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M4
        buttonText:  "M4"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M3.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M5
        buttonText:  "M5"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M4.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M6
        buttonText:  "M6"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M5.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M7
        buttonText:  "M7"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M6.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M8
        buttonText:  "M8"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M7.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M9
        buttonText:  "M9"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M8.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M10
        buttonText:  "M10"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M9.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M11
        buttonText:  "M11"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M10.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

    YaLabel {
        id: daikin1M12
        buttonText:  "M12"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M11.bottom 
            horizontalCenter: rectangle1.horizontalCenter
        }
    }

// --------------------------------------------------- rectangle2

    YaLabel {
        id: daikinName2
        buttonText:  ""
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: (app.daikinCount > 1 ) ? rectangle2.top : offscreenAnchor.bottom
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M0
        buttonText:  "M0"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinName2.bottom
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M1
        buttonText:  "M1"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M0.bottom
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M2
        buttonText:  "M2"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M1.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M3
        buttonText:  "M3"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M2.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M4
        buttonText:  "M4"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M3.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M5
        buttonText:  "M5"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M4.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M6
        buttonText:  "M6"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M5.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M7
        buttonText:  "M7"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M6.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M8
        buttonText:  "M8"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M7.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M9
        buttonText:  "M9"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M8.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M10
        buttonText:  "M10"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M9.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M11
        buttonText:  "M11"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M10.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

    YaLabel {
        id: daikin2M12
        buttonText:  "M12"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M11.bottom 
            horizontalCenter: rectangle2.horizontalCenter
        }
    }

// --------------------------------------------------- rectangle3

    YaLabel {
        id: daikinName3
        buttonText:  ""
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: (app.daikinCount > 2 ) ? rectangle3.top : offscreenAnchor.bottom
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M0
        buttonText:  "M0"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinName3.bottom
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M1
        buttonText:  "M1"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M0.bottom
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M2
        buttonText:  "M2"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M1.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M3
        buttonText:  "M3"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M2.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M4
        buttonText:  "M4"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M3.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M5
        buttonText:  "M5"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M4.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M6
        buttonText:  "M6"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M5.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M7
        buttonText:  "M7"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M6.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M8
        buttonText:  "M8"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M7.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M9
        buttonText:  "M9"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M8.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M10
        buttonText:  "M10"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M9.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M11
        buttonText:  "M11"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M10.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

    YaLabel {
        id: daikin3M12
        buttonText:  "M12"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M11.bottom 
            horizontalCenter: rectangle3.horizontalCenter
        }
    }

// --------------------------------------------------- rectangle4

    YaLabel {
        id: daikinName4
        buttonText:  ""
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: (app.daikinCount > 3 ) ? rectangle4.top : offscreenAnchor.bottom
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M0
        buttonText:  "M0"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinName4.bottom
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M1
        buttonText:  "M1"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M0.bottom
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M2
        buttonText:  "M2"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M1.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M3
        buttonText:  "M3"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M2.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M4
        buttonText:  "M4"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M3.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M5
        buttonText:  "M5"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M4.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M6
        buttonText:  "M6"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M5.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M7
        buttonText:  "M7"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M6.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M8
        buttonText:  "M8"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M7.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M9
        buttonText:  "M9"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M8.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M10
        buttonText:  "M10"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M9.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M11
        buttonText:  "M11"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M10.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

    YaLabel {
        id: daikin4M12
        buttonText:  "M12"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M11.bottom 
            horizontalCenter: rectangle4.horizontalCenter
        }
    }

// --------------------------------------------------- rectangle5 Totals

    YaLabel {
        id: daikinName5
        buttonText:  "Totals"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: (app.daikinCount > 1 ) ? rectangle0.top : offscreenAnchor.bottom
            horizontalCenter: (app.daikinCount == 2 ) ? rectangle3.horizontalCenter : (app.daikinCount == 3 ) ? rectangle4.horizontalCenter : rectangle5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M0
        buttonText:  "M0"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikinName5.bottom
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M1
        buttonText:  "M1"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M0.bottom
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M2
        buttonText:  "M2"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M1.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M3
        buttonText:  "M3"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M2.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M4
        buttonText:  "M4"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M3.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M5
        buttonText:  "M5"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M4.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M6
        buttonText:  "M6"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M5.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M7
        buttonText:  "M7"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M6.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M8
        buttonText:  "M8"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M7.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M9
        buttonText:  "M9"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M8.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M10
        buttonText:  "M10"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M9.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M11
        buttonText:  "M11"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "lightgrey"
        buttonHoverColor: "lightgrey"
        buttonSelectedColor : "lightgrey"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M10.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

    YaLabel {
        id: daikin5M12
        buttonText:  "M12"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: "white"
        buttonHoverColor: "white"
        buttonSelectedColor : "white"
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin5M11.bottom 
            horizontalCenter: daikinName5.horizontalCenter
        }
    }

// --------------------------------------------------- bottom row with graphs buttons

    YaLabel {
        id: daikinGraphs1
        buttonText:  "Graphs"
        height: fieldheight
        width: fieldwidth / 2
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin1M12.bottom
            topMargin : fieldheight
            horizontalCenter: rectangle1.horizontalCenter
        }
        onClicked: {
            daikinIndex = 0
            stage.openFullscreen(app.daikinGraphsUrl);
        }
    }

    YaLabel {
        id: daikinGraphs2
        buttonText:  "Graphs"
        height: fieldheight
        width: fieldwidth / 2
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin2M12.bottom
            topMargin : fieldheight
            horizontalCenter: rectangle2.horizontalCenter
        }
        onClicked: {
            daikinIndex = 1
            stage.openFullscreen(app.daikinGraphsUrl);
        }
    }

    YaLabel {
        id: daikinGraphs3
        buttonText:  "Graphs"
        height: fieldheight
        width: fieldwidth / 2
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin3M12.bottom
            topMargin : fieldheight
            horizontalCenter: rectangle3.horizontalCenter
        }
        onClicked: {
            daikinIndex = 2
            stage.openFullscreen(app.daikinGraphsUrl);
        }
    }

    YaLabel {
        id: daikinGraphs4
        buttonText:  "Graphs"
        height: fieldheight
        width: fieldwidth / 2
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            top: daikin4M12.bottom
            topMargin : fieldheight
            horizontalCenter: rectangle4.horizontalCenter
        }
        onClicked: {
            daikinIndex = 3
            stage.openFullscreen(app.daikinGraphsUrl);
        }
    }

// --------------------------------------------------- bottom line

// Message about totals

    Text {
        id: totalsMessage
//        text: (app.daikinCount > 1 ) ? "Totals are only correct when IP addresses differ." : ""
        text: (app.daikinCount > 1 ) ? "" : ""
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

// --------------------------------------------------- offscreenAnchor

    Text {
        id: offscreenAnchor
        text: "offscreenAnchor"
        anchors {
            top: parent.bottom
            topMargin: isNxt ? 20 : 16
        }
    }

}

