/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

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
    property string uploadPath: "file:///home/yhs/serv/user01"
    property string account:""
    function getmsg(msg){
        account = msg;
        console.log("get login account:"+account);
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
        function format(integer){
            var integerlen = integer.toString().length;
            var formated;
            if(integerlen == 2)
                formated = "00" + integer;
            else if(integerlen == 3)
                formated = "0" + integer;
            return formated;
        }

        function uploadData(){
            var index = 0;
            io.source = uploadPath;
            io.read();
            var data = io.text;
            var datalen = data.length;
            var ac = account;
            var aclen = ac.length;
            var alllen = 6+aclen+datalen;
            var formatdatalen = format(datalen);
            var formatalllen = format(alllen);
            if(aclen.toString().length == 1)
                aclen = "0"+ aclen;
            console.log("datalen="+datalen);
            console.log(formatdatalen)
            console.log(alllen);
            console.log(formatalllen);
            var newData = "05" + formatalllen + aclen + ac + formatdatalen + data
            console.log(newData);
            upload.connectHost();
            upload.construction = newData;
            upload.writeMessage();
        }
        Rectangle {
            id: upButton
            anchors.right: banner.right
            anchors.rightMargin: 20
            anchors.verticalCenter: banner.verticalCenter
            visible: true
            width: 2 * arrow.width
            height:arrow.height
            color: "red"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(account != "")
                        banner.uploadData();
                }
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
       /* function updateIndexModel(){
            console.log("update get Msg");
            console.log(clien.text);
            var records = clien.text.split("|");
            var index = 0;
            userIndex.clear();
            for(; index < records.length; index++){
                var data = records[index].split(',');
                if (data.length === 7){
                    userIndex.append(userIndex.createUserIndex(data));
                    //console.log(data[0]);
                    var mydate=new Date(data[0]);
                    var mydate1=new Date(2016,0,26);
                    console.log(mydate);
                    console.log(mydate1);
                }
            }
            if (userIndex.count > 0) {
                userIndex.ready = true;
                userIndex.userScore = userIndex.get(0).changed;
                userIndex.userScoreChanged = userIndex.count > 1 ?
                            (Math.round((userIndex.userScore - userIndex.get(1).pulse) * 100) / 100) : 0;
                userIndex.dataReady(); //emit signal
            }
        }*/

        Clien {
            id:clien
            onTextChanged: root.updateIndexModel()
        }
        MySQL{
            id : mySQL
            onRetriveDetailBaseStatusChanged: {updateIndexModel(status)}
            /*date, pressure heartRate temperature pulse score changed*/
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
                        userIndex.dataReady()
                    }
                    else userIndex.ready = false
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
            //onUserIdChanged: root.sendRequest()
            onUserIdChanged: mySQL.retriveUserDetailInfo(userId)
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
