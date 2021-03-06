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

Rectangle {
    id: root
    width: 440
    height: 160
    color: "transparent"

    property var userIndex: null

    Text {
        id: userIdText
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 15
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 38
        font.weight: Font.DemiBold
        text: root.userIndex.userId
    }

    Text {
        id: userNameText
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: scoreChangePercentage.bottom
        anchors.right: scoreChangePercentage.left
        anchors.rightMargin: 15
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 16
        elide: Text.ElideRight
        text: root.userIndex.userName
    }

    Text {
        id: score
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 15
        horizontalAlignment: Text.AlignRight
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 15
        font.weight: Font.DemiBold
        text: "score:"+(Math.round(root.userIndex.userScore)*100)/100
    }

    Text {
        id: scoreChange
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: score.bottom
        anchors.topMargin: 5
        horizontalAlignment: Text.AlignRight
        color: root.userIndex.userScoreChanged < 0 ? "#d40000" : "#328930"
        font.family: "Open Sans"
        font.pointSize: 10
        font.weight: Font.Bold
        text: "change:"+root.userIndex.userScoreChanged
    }

    Text {
        id: scoreChangePercentage
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: scoreChange.bottom
        anchors.topMargin: 5
        horizontalAlignment: Text.AlignRight
        color: root.userIndex.userScoreChanged < 0 ? "#d40000" : "#328930"
        font.family: "Open Sans"
        font.pointSize: 18
        font.weight: Font.Bold
        text: "percent:"+Math.abs(Math.round(root.userIndex.userScoreChanged/(root.userIndex.userScore - root.userIndex.userScoreChanged) * 100))/100  +"%"
    }
}
