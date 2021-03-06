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
import IOs 1.0
Rectangle {
    id: root
    width: 320
    height: 410
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    color: "white"

    property string currentUserId: ""
    property string currentUserName: ""
    FileIO{
        id: io
    }
    Clien{
        id: baseData
        onTextChanged:view.setBaseData()
    }

    function updateBaseUserData(){
        //io.source = "file:///home/yhs/Desktop/stock.json";
        //io.source = "file:///home/yhs/serv/basedata.json"
       // io.read();
       // var data = JSON.parse(io.text);
        //var j = data.length
        //for(var i =0; i < data.length; i++){
        //    view.model.append(data[i]);
       // }
        baseData.connectHost();
        baseData.construction = "030000";
        baseData.writeMessage();
    }
    Component.onCompleted: updateBaseUserData()
    ListView {
        id: view
        anchors.fill: parent
        width: parent.width
        clip: true
        keyNavigationWraps: true
        highlightMoveDuration: 0
        focus: true
        snapMode: ListView.SnapToItem
        model: UserListModel{}
        function setBaseData() {
           /* var records = clien.text.split(';');
            console.log(records[0]);
            console.log(records.length);
            var index = 0;
            for(;index < records.length;index++){
                var data = records[index].split(',');
                model.setProperty(index, "value", data[0]);
                var today = parseFloat(data[0]);
                var yesterday = parseFloat(data[1]);
                var change = today - yesterday;
                if (change >= 0.0)
                    model.setProperty(index, "change", "+" + change.toFixed(2));
                else
                    model.setProperty(index, "change", change.toFixed(2));

                var changePercentage = (change / yesterday) * 100.0;
                if (changePercentage >= 0.0)
                    model.setProperty(index, "changePercentage", "+" + changePercentage.toFixed(2) + "%");
                else
                    model.setProperty(index, "changePercentage", changePercentage.toFixed(2) + "%");
                console.log(data[0]);
                console.log(data[1]);
            }
            */
            var data = JSON.parse(baseData.text);
            console.log(baseData.text);
            for(var i=0; i<data.length; i++){
                //UserListModel.append(data[i]);
                view.model.append(data[i]);
            }
        }
        function sendRequest(){
            clien.construction = "1"+view.model.count;
            clien.writeMessage();
        }

        onCurrentIndexChanged: {
            mainRect.listViewActive = 0;
            root.currentUserId = model.get(currentIndex).userId;
            root.currentUserName = model.get(currentIndex).gender;
        }

        delegate: Rectangle {
            height: 102
            width: parent.width
            color: "transparent"
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    view.currentIndex = index;
                }
            }

            Text {
                id: userIdText
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 15
                width: 125
                height: 40
                color: "#000000"
                font.family: "Open Sans"
                font.pointSize: 20
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                text: userId
            }

            Text {
                id: scoreText
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 0.31 * parent.width
                width: 190
                height: 40
                color: "#000000"
                font.family: "Open Sans"
                font.pointSize: 20
                font.bold: true
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: value
                //Component.onCompleted: view.sendRequest();
            }

            Text {
                id: scoreChangeText
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 20
                width: 135
                height: 40
                color: "#328930"
                font.family: "Open Sans"
                font.pointSize: 20
                font.bold: true
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: change
                onTextChanged: {
                    if (parseFloat(text) >= 0.0)
                        color = "#328930";
                    else
                        color = "#d40000";
                }
            }

            Text {
                id: userNameText
                anchors.top: userIdText.bottom
                anchors.left: parent.left
                anchors.leftMargin: 15
                width: 330
                height: 30
                color: "#000000"
                font.family: "Open Sans"
                font.pointSize: 16
                font.bold: false
                elide: Text.ElideRight
                maximumLineCount: 1
                verticalAlignment: Text.AlignVCenter
                text: gender
            }

            Text {
                id: scoreChangePercentageText
                anchors.top: userIdText.bottom
                anchors.right: parent.right
                anchors.rightMargin: 20
                width: 120
                height: 30
                color: "#328930"
                font.family: "Open Sans"
                font.pointSize: 18
                font.bold: false
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: changePercentage
                onTextChanged: {
                    if (parseFloat(text) >= 0.0)
                        color = "#328930";
                    else
                        color = "#d40000";
                }
            }

            Rectangle {
                id: endingLine
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                height: 1
                width: parent.width
                color: "#d7d7d7"
            }
        }

        highlight: Rectangle {
            width: parent.width
            color: "#eeeeee"
        }
    }
}
