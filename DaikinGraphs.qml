import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
    id: root
    screenTitle: qsTr("Energy usage '" + app.daikinNames[daikinIndex] + "' last 12 months")

    property int graphWidth : isNxt ? 300 : 240

    property int fieldheight : isNxt ? 30 : 24
  
    property int fieldwidth : isNxt ? 170 : 136

    property string    activeColor: "lightblue"
    property string    hoverColor: "lightblue"
    property string    selectedColor : "yellow"

    property int currentMonth
	property int monthnumber

    property int daikinIndex

    property variant last_year_heat  : [0,0,0,0,0,0,0,0,0,0,0,0,0]
    property variant last_year_cool  : [0,0,0,0,0,0,0,0,0,0,0,0,0]
    property variant last_year_energy : [0,0,0,0,0,0,0,0,0,0,0,0,0]
    property variant month_pointer   : [0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    property real maxValue : 0

    property bool graphClicked : false
    
// --------------------------------------------------- on show / hide

    onVisibleChanged: {
        if (visible) {
            addCustomTopRightButton("Exit");
            daikinIndex = app.daikinEnergy.daikinIndex
            updateGraphs()
            graphClicked = false
        }
    }

// --------------------------------------------------- Hide on Exit button

    onCustomButtonClicked: {
        hide();
    }

// --------------------------------------------------- Update Graphs

    function updateGraphs() {

// create data for graph : keep '0' in last_year_x[0] and add 12 month values
       
        for (var i=1 ; i < 13 ; i++ ) {

            last_year_heat[i] = Math.round(app.last_year_heat[daikinIndex][i-1])
            last_year_cool[i] = Math.round(app.last_year_cool[daikinIndex][i-1])
            last_year_energy[i] = Math.round(app.last_year_energy[daikinIndex][i-1])

            if ( last_year_energy[i] > maxValue ) maxValue = last_year_energy[i]
        }
        
// this array is used by all three graphs for a single bar as indicator for the current month
// size is biggest value of energy

        var d = new Date();
        currentMonth = d.getMonth() + 1;

		monthnumber = parseInt(Qt.formatDate (d,"M"))

        month_pointer[currentMonth] = 0
        for ( var i = 1; i < 13 ; i++ )  {
            if ( month_pointer[currentMonth] < last_year_energy[i] )  month_pointer[currentMonth] = last_year_energy[i]
        }

// trigger the graphs to update themselves with new values

        monthbarGraphHeat.trigger = true
        monthbarGraphCool.trigger = true
        monthbarGraphTotal.trigger = true

    }

// --------------------------------------------------- Graphs

	TriggerBarGraph {
        id: monthbarGraphHeat
        anchors {
            top : parent.top
            left : parent.left
            leftMargin : isNxt? 20:16
        }
        height:  isNxt? parent.height-100:parent.height-80
        width: graphWidth
//        width:  isNxt? parent.width-50:parent.width-40

        triggerMode : true
        toggleValuesOnBar : true
        barWidthFactor1 : 4
        rotateValuesOnBar : 315

        isManualMax : true
        manualMax : maxValue
        
        titleText: "Heat in kWh"
        titleFont: qfont.bold.name
        titleSize: isNxt ? 20 : 16
        showTitle: true
        backgroundcolor : "lightgrey"
        axisColor : "black"
        barColor : "blue"
        lineXaxisvisible : true
        textXaxisColor : "red"
        stepXtext: 1
        valueFont: qfont.regular.name
        valueSize: isNxt ? 13 : 10
        valueTextColor : "black"
        levelColor :"red"
        levelTextColor : "blue"
        showValuesOnBar : false
        showLevels  : true
//        showLevels  : false
        showValuesOnLevel : true
//        showValuesOnLevel : false
//        specialBarColor :"red"
        specialBarColor :"blue"
        specialBarIndex  : currentMonth
        showSpecialBar : true
        dataValues: last_year_heat
        
        barColor2: "red"
        dataValues2: month_pointer
        
        onClicked: { graphClicked = true }
    }


	TriggerBarGraph {
        id: monthbarGraphCool
        anchors {
            top : parent.top
            horizontalCenter : parent.horizontalCenter
        }
        height:  isNxt? parent.height-100:parent.height-80
        width: graphWidth
//        width:  isNxt? parent.width-50:parent.width-40

        triggerMode : true
        toggleValuesOnBar : true
        barWidthFactor1 : 4
        rotateValuesOnBar : 315

        isManualMax : true
        manualMax : maxValue
        
        titleText: "Cool in kWh"
        titleFont: qfont.bold.name
        titleSize: isNxt ? 20 : 16
        showTitle: true
        backgroundcolor : "lightgrey"
        axisColor : "black"
        barColor : "blue"
        lineXaxisvisible : true
        textXaxisColor : "red"
        stepXtext: 1
        valueFont: qfont.regular.name
        valueSize: isNxt ? 13 : 10
        valueTextColor : "black"
        levelColor :"red"
        levelTextColor : "blue"
        showValuesOnBar : false
        showLevels  : true
//        showLevels  : false
        showValuesOnLevel : true
//        showValuesOnLevel : false
//        specialBarColor :"red"
        specialBarColor :"blue"
        specialBarIndex  : currentMonth
        showSpecialBar : true
        dataValues: last_year_cool
        
        barColor2: "red"
        dataValues2: month_pointer

        onClicked: { graphClicked = true }
    }


	TriggerBarGraph {
        id: monthbarGraphTotal
        anchors {
            top : parent.top
            right : parent.right
            rightMargin : isNxt? 20:16
        }
        height:  isNxt? parent.height-100:parent.height-80
        width: graphWidth
//        width:  isNxt? parent.width-50:parent.width-40

        triggerMode : true
        toggleValuesOnBar : true
        barWidthFactor1 : 4
        rotateValuesOnBar : 315

        isManualMax : true
        manualMax : maxValue
        
        titleText: "Totals in kWh"
        titleFont: qfont.bold.name
        titleSize: isNxt ? 20 : 16
        showTitle: true
        backgroundcolor : "lightgrey"
        axisColor : "black"
        barColor : "blue"
        lineXaxisvisible : true
        textXaxisColor : "red"
        stepXtext: 1
        valueFont: qfont.regular.name
        valueSize: isNxt ? 13 : 10
        valueTextColor : "black"
        levelColor :"red"
        levelTextColor : "blue"
        showValuesOnBar : false
        showLevels  : true
//        showLevels  : false
        showValuesOnLevel : true
//        showValuesOnLevel : false
//        specialBarColor :"red"
        specialBarColor :"blue"
        specialBarIndex  : currentMonth
        showSpecialBar : true
        dataValues: last_year_energy
        
        barColor2: "red"
        dataValues2: month_pointer

        onClicked: { graphClicked = true }
    }

// --------------------------------------------------- Buttons

    YaLabel {
        id: daikinPrev
        buttonText:  "<- Previous"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            bottom:        (daikinIndex == 0 ) ? parent.top      : parent.bottom
            bottomMargin : (daikinIndex == 0 ) ? 4 * fieldheight : fieldheight
            horizontalCenter : monthbarGraphHeat.horizontalCenter
        }
        onClicked: {
            if (daikinIndex > 0) { 
                graphClicked = true
                daikinIndex = daikinIndex - 1
                updateGraphs()
            }
        }
    }

    YaLabel {
        id: daikinNext
        buttonText:  "Next ->"
        height: fieldheight
        width: fieldwidth
        buttonActiveColor: activeColor
        buttonHoverColor: hoverColor
        buttonSelectedColor : selectedColor
        enabled : true
        selected : false
        textColor : "black"
        anchors {
            bottom:        (daikinIndex == app.daikinCount - 1 ) ? parent.top      : parent.bottom
            bottomMargin : (daikinIndex == app.daikinCount - 1 ) ? 4 * fieldheight : fieldheight
            horizontalCenter : monthbarGraphTotal.horizontalCenter
        }
        onClicked: {
            if (daikinIndex < app.daikinCount - 1 ) { 
                graphClicked = true
                daikinIndex = daikinIndex + 1 ;
                updateGraphs()
             }            
        }
    }
// --------------------------------------------------- bottom line

// Message about graph values

    Text {
        id: graphsMessage
        text: (!graphClicked) ? "Click any graph to show / hide graph values" : ""
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
