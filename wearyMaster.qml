
import QtQuick 2.0
import QtQml.Models 2.1
import IOs 1.0
import SQL 1.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "./content"

ApplicationWindow{
    id: mainRect
    width: 1000
    height: 700
    flags: Qt.FramelessWindowHint
    color: "transparent"

    property int listViewActive: 0
    property string account:""
    signal exitProc
    function receiveAc(ac){
        account = ac;
    }
    MouseArea{
        id:mouse
        x:0
        y:0
        width: 1000
        height: 700
        property var  pressedX
        property var  pressedY
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onPositionChanged: {
            mainRect.x += (mouse.x - pressedX)
            mainRect.y += (mouse.y - pressedY)
        }
    }
    Rectangle{
        opacity: 1
        width:  1000
        height: 700
        radius:  15
        border.width: 10
        Rectangle {
            id: banner
            height: 80
            x:parent.border.width
            y:x
            width: parent.width - 2 * parent.border.width
            color: "#000000"
            FileIO{
                id: io
            }
            Clien{
                id:upload
                onTextChanged: {
                    console.log(upload.text);
                }
            }
            function uploadData(){
                io.setSource("file:///home/yhs/Desktop/pdf/healthyInfo")
                io.read()
                console.log(io.text)
                var newData = JSON.parse(io.text)
                mySQL.uploadTodayInfo(account, newData[0]["date"], newData[0]["heartRate"],
                                      newData[0]["temperature"], newData[0]["pressure"], newData[0]["pulse"])
            }
            SelectBtn{
                id:exitProc
                onBtnClicked:mainRect.exitProc()
                text:"EXIT"
                color:"red"
                anchors.right: banner.right
                anchors.top: banner.top
                anchors.margins: 20
            }

            Image {
                id: arrow
                source: "./content/images/icon-left-arrow.png"
                anchors.left: banner.left
                anchors.leftMargin: 20
                anchors.verticalCenter: banner.verticalCenter
                visible: root.currentIndex == 1 ? true : false

                MouseArea {
                    anchors.fill: parent
                    onClicked: listViewActive = 1;
                }
            }

            Item {
                id: textItem
                width: wearyText.width + masterText.width
                height: wearyText.height + masterText.height
                anchors.horizontalCenter: banner.horizontalCenter
                anchors.verticalCenter: banner.verticalCenter

                Text {
                    id: wearyText
                    anchors.verticalCenter: textItem.verticalCenter
                    color: "#ffffff"
                    font.family: "Abel"
                    font.pointSize: 40
                    text: "weary"
                }
                Text {
                    id: masterText
                    anchors.verticalCenter: textItem.verticalCenter
                    anchors.left: wearyText.right
                    color: "#5caa15"
                    font.family: "Abel"
                    font.pointSize: 40
                    text: "Master"
                }
            }

        }

        ListView {
            id: root
            objectName: "userListView"
            function retriveBaseInfo(){
                listView.retriveBaseInfo()
            }

            x:parent.border.width
            y:parent.border.width+banner.height
            width: parent.width - 2 * parent.border.width
            height: parent.height - 2* parent.border.width - banner.height
            snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 250
            focus: false
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: listViewActive == 0 ? 1 : 0
            signal currenIndexInTwo
            onCurrentIndexChanged: {
                if (currentIndex == 1 || currentIndex == 2)
                    listViewActive = 0;
                else if(currentIndex == 0)
                    listViewActive = 1;
            }
            Clien {
                id:clien
                onTextChanged: root.updateIndexModel()
            }
            MySQL{
                id : mySQL
                onRetriveDetailBaseStatusChanged: {updateIndexModel(status)}
                onUploadStatusChanged: {
                    console.log(status)
                }
                function updateIndexModel(status){
                    if(status === true){
                        console.log(getDetailInfo())
                        var detailInfo = JSON.parse(getDetailInfo())
                        console.log("detailInfo length:" + detailInfo.length)
                        userIndex.clear()
                        for(var i=0; i<detailInfo.length; i++){
                            userIndex.append(detailInfo[i])
                        }

                        if(userIndex.count>0){
                            userIndex.ready = true

                        }
                        else userIndex.ready = false
                        userIndex.dataReady()
                    }
                }
            }
            IndexModel {
                id: userIndex
                userId: listView.currentUserId
                userName: listView.currentUserName
                userScore: listView.currentScore
                userScoreChanged: listView.currentChanged
                onUserIdChanged: {
                    ready = false
                    if(dataLength === "WEEK")
                        mySQL.retriveUserDetailInfo(userId, MySQL.WEEK)
                    else if(dataLength === "MONTH")
                        mySQL.retriveUserDetailInfo(userId, MySQL.MONTH)
                    else if(dataLength === "YEAR")
                        mySQL.retriveUserDetailInfo(userId, MySQL.YEAR)
                    else
                        mySQL.retriveUserDetailInfo(userId, MySQL.MAX)
                }
                onDataReady: {
                    root.positionViewAtIndex(1, ListView.SnapPosition)
                    indexView.update()
                }
            }
            model: ObjectModel {
                UserListView {
                    id: listView
                    width: root.width
                    height: root.height
                    visible: listViewActive == 1 ? 1 : 0

                }

                IndexView {
                    id: indexView
                    width: root.width
                    height: root.height
                    userlist: listView
                    userIndex: userIndex
                    visible: listViewActive==0 && root.currentIndex == 1
                }

                PersonalInfoView{
                    id:personalInfoView
                    width:root.width
                    height:root.height
                    name : listView.currentUserName
                    region:listView.currentRegion
                    date:listView.currentBirthDate
                    sex:listView.currentSex
                    uploadtime: listView.currentUploadTimes
                    userID: listView.currentUserId
                    score:listView.currentScore
                    visible: listViewActive==0 && root.currentIndex == 2
                }
            }
        }
    }
}
