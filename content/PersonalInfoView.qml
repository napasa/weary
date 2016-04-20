import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1
import SQL 1.0
import IOs 1.0
import Qt.labs.settings 1.0
Rectangle {
    id:root
    width: 1000 - 20
    height: 700 - 100
    property string name: "unknown"
    property string region: "unknown"
    property  string date: "unknown"
    property string sex: "unknown"
    property int uploadtime
    property  double score
    property string userID:""
    property bool mainPageHasFocus:false
    onFocusChanged: {
        if(focus == true){
            if(io.isFileExist(userID)===true){
                image.source ="file://" + io.currentPath() + "/UserPicture/"+userID+".jpg"
                root.mainPageHasFocus = true
                return
            }
            var path = sql.retriveUserPic(root.userID);
         //   console.log(path)
            if(path === "error"){
                image.source ="file://" + io.currentPath() + "/UserPicture/default.jpg"
                root.mainPageHasFocus = true
                return;
            }
           image.source = "file://" + path
            root.mainPageHasFocus = true
        }
        else{
            mainPageHasFocus =false
        }
    }
    FileIO{
        id:io
    }

    Rectangle{
        id:personalInfo
        width: 400
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10
        Image{
            id:image
            width: 300
            height: 300
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.topMargin: 20
            anchors.top: parent.top
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
        }
        SiblingLable{
            id:mediumLable
            anchors.top:image.bottom
            lableText: "BaseInformation:"
            lableSize:30
        }

        SiblingLable{
            id:name
            anchors.top: mediumLable.bottom
            anchors.topMargin: 20
            lableText: "Name:"
            infoText:root.name
        }
        SiblingLable{
            id:uploadTime
            anchors.top: name.bottom
            lableText: "UploadTimes:"
            infoText: root.uploadtime
        }
        SiblingLable{
            id:birth
            anchors.top:uploadTime.bottom
            lableText: "BirthDate:"
            infoText: root.date
        }
        SiblingLable{
            id:region
            anchors.top:birth.bottom
            lableText: "Region:"
            infoText: root.region
        }
        SiblingLable{
            id:score
            anchors.top:region.bottom
            lableText: "Score:"
            infoText: root.score
        }
        SiblingLable{
            id:sex
            anchors.top:score.bottom
            lableText: "Sex:"
            infoText: root.sex
        }
    }
    Rectangle{
        id:modification
        width: 600
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        Text{
            id:title
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 20
            text:"Modification:"
            font.pixelSize: 30
        }

        SiblingEditable{
            id:siblingName
            anchors.top: title.bottom
            labelText:"Name:"
            inputText: root.name
        }
        SiblingEditable{
            id:siblingDate
            anchors.top:siblingName.bottom
            labelText:"BirthDate:"
            inputText: root.date
        }
        SiblingEditable{
            id:siblingGender
            anchors.top: siblingDate.bottom
            labelText: "Sex:"
            inputText: root.sex
        }
        SiblingEditable{
            id:siblingRegion
            anchors.top: siblingGender.bottom
            labelText:"Region"
            inputText: root.region
        }

        Text{
            id:siblingPicPath
            anchors.top: siblingRegion.bottom
            anchors.left: parent.left
            anchors.margins: 10
            anchors.leftMargin: 20
            elide : Text.ElideRight
            font.pixelSize: 20
            width: 500
            height: 25
            property string labelText: "PicPath:  "
            property string inputText: picSettings.picPath
            text:labelText+"     "+inputText
            Component.onDestruction: picSettings.picPath = siblingPicPath.inputText
            Settings{
                id:picSettings
                property string picPath: "./UserPicture/default.jpg"
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    fileDialog.openDialog(siblingPicPath.labelText)
                }
            }
        }
        Text {
            id:siblingDataPath
            anchors.top:siblingPicPath.bottom
            anchors.left: parent.left
            anchors.margins: 10
            anchors.leftMargin: 20
            elide : Text.ElideRight
            font.pixelSize: 20
            width: 500
            height: 25
            property string labelText: "DataPath:   "
            property string inputText: dataSettings.dataPath
            text:labelText +" "+inputText
            Component.onDestruction: dataSettings.dataPath = siblingDataPath.inputText
            Settings{
                id:dataSettings
                property string dataPath:"./Data/indexData.dat"
            }

            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    fileDialog.openDialog(siblingDataPath.labelText)
                }
            }
        }
        SelectBtn{
            id:confirm
            width: 150
            text:"Update"
            anchors.top: siblingDataPath.bottom
            anchors.left: parent.left
            anchors.leftMargin: siblingDataPath.anchors.leftMargin
            anchors.topMargin: 10
            mouseEnabled: mainRect.account===root.userID
            MySQL{
                id:sql
           }

            onBtnClicked: {
             var ret =   sql.updateBaseInfo(siblingName.inputText, siblingDate.inputText, siblingGender.inputText,
                                   siblingRegion.inputText, siblingPicPath.inputText, mainRect.account)
                console.log("update ret=" + ret)
            }
        }
        UploadTableView{
            id:tableView
            anchors.top:confirm.bottom
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: siblingDataPath.anchors.leftMargin
            mainPageHasFocus: root.mainPageHasFocus
        }

        SelectBtn{
            id:upload
            width:150
            text:"Commit"
            anchors.left: parent.left
            anchors.leftMargin: siblingDataPath.anchors.leftMargin
            anchors.top: tableView.bottom
            anchors.topMargin: 20
            onBtnClicked: {tableView.timeToUpload=true}
        }
    }
    HelpWindow{
        id:helpWin
        Component.onCompleted: {
            io.setSource("./Data/help.html")
            io.read()
        }
        Connections{
            target: io
            onTextChanged:{
                helpWin.helpText = io.text
            }
        }
    }

    FileDialog{
        id:fileDialog
        property var obj
        onAccepted: {
            if(obj === siblingDataPath.labelText)
                siblingDataPath.inputText = fileUrl
            else{
                siblingPicPath.inputText = fileUrl
            }
        }
        function openDialog(object){
            obj = object
            open()
        }
    }
}



