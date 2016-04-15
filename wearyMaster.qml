
import QtQuick 2.0
import QtQml.Models 2.1
import IOs 1.0
import SQL 1.0
import "./content"

Rectangle {
    id: mainRect
    width: 1000
    height: 700

    property int listViewActive: 0
    property string account:""
    function getmsg(msg){
        account = msg;
    }

    Rectangle {
        id: banner
        height: 80
        anchors.top: parent.top
        width: parent.width
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
        Rectangle {
            id: upButton
            anchors.right: banner.right
            anchors.rightMargin: 20
            anchors.verticalCenter: banner.verticalCenter
            visible: true
            width: 3 * arrow.width
            height:arrow.height
            color: "red"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(account != "")
                        banner.uploadData();
                }
            }
            Text {
                id:uploadText
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height
                text:"upload"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
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
        width: parent.width
        anchors.top: banner.bottom
        anchors.bottom: parent.bottom
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 250
        focus: false
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: listViewActive == 0 ? 1 : 0
        onCurrentIndexChanged: {
            if (currentIndex == 1)
                listViewActive = 0;
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

        function sendRequest(){
            var idLenLen = listView.currentUserId.length.toString().length;
            var id = listView.currentUserId
            var idLen = listView.currentUserId.length
            if(idLenLen == 1)
                idLen = "000" + idLen;
            else if(idLenLen == 2)
                idLen = "00" + idLen;
            console.log("the req = 04" + idLen + listView.currentUserId);
            clien.connectHost();
            clien.construction = "04"+idLen + listView.currentUserId;
            clien.writeMessage();
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
            }

            IndexView {
                id: indexView
                width: root.width
                height: root.height
                userlist: listView
                userIndex: userIndex
            }
        }
    }
}
