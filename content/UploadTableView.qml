import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import IOs 1.0
import SQL 1.0

TableView {
    id:table
    width: parent.width-78
    height: 130
    property bool mainPageHasFocus:false
    property alias timeToUpload: libraryModel.timeToUpload
    onMainPageHasFocusChanged: {
        if(mainPageHasFocus==true){
            fileIO.readData()
        }
    }

    FileIO{
        id:fileIO
        function readData()
        {
            setSource("file:///home/yhs/WearyMaster/healthyInfo.json")
            read()
        }
        onTextChanged: {
            var jsonText = JSON.parse(fileIO.text)
            console.log("uploadData:"+jsonText.length)
            var i=0;
            while(i<jsonText.length){
                libraryModel.append(jsonText[i])
                i++
            }
        }
    }
    onFocusChanged: {
        if(focus==true)
            fileIO.readData()
    }
    MySQL{
        id:sql
    }
    ListModel {
        id: libraryModel
        property bool timeToUpload: false
        onTimeToUploadChanged: {
            if(timeToUpload === true){
                var i=0;
                var object
                var status
                while(i !=libraryModel.count){
                    object = get(i)
                    status =sql.uploadTodayInfo(mainRect.account, object.date, object.heartRate,
                                        object.temperature, object.pressure, object.pulse)
                    if(status === false)
                        break
                    i++
                }
                timeToUpload = false
            }
        }
    }
    TableViewColumn{
        role:"date"
        title:"Date"
        width:115
    }
    TableViewColumn {
        role: "heartRate"
        title: "HeartRate"
        width: 100
    }
    TableViewColumn {
        role: "temperature"
        title: "Temperature"
        width: 105
    }
    TableViewColumn{
        role:"pressure"
        title:"Pressure"
        width:100
    }
    TableViewColumn{
        role:"pulse"
        title:"Pulse"
        width:100
    }
    model: libraryModel
    style: TableViewStyle {
        headerDelegate: Rectangle {
            height: headerItem.implicitHeight * 1.2
            width: headerItem.implicitWidth
            radius: 15
            Text {
                id: headerItem
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: styleData.textAlignment
                anchors.leftMargin: 12
                text: styleData.value
                elide: Text.ElideRight
                color: "#14aaff"
                renderType: Text.NativeRendering
            }
        }
        itemDelegate: Rectangle{
            color : "#040404"
            height: infoItem.Height * 1.2
            width: infoItem.Width
            radius: 15
            Text {
                id: infoItem
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: styleData.textAlignment
                anchors.leftMargin: 12
                text: styleData.value
                color:"#14aaff"
                renderType: Text.NativeRendering
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    parent.color = "pink"
                }
                onReleased: {
                    parent.color = "#040404"
                }
            }
        }
    }

}
