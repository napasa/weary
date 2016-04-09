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

    property bool drawPressureIndex: pressureButton.buttonEnabled
    property bool drawPulseIndex: pulseButton.buttonEnabled
    property bool drawHeartRateIndex: heartRateButton.buttonEnabled
    property bool drawTemperaturePrice: temperatureButton.buttonEnabled

    property string pressureColor: "#face20"
    property string pulseColor: "#14aaff"
    property string heartRateColor: "#80c342"
    property string temperatureColor: "#f30000"
    property string scoreColor: "#14aaff"

    Text {
        id: pressureText
        anchors.left: root.left
        anchors.top: root.top
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 19
        text: "Pressure"
    }

    Text {
        id: pulseText
        anchors.left: root.left
        anchors.top: pressureText.bottom
        anchors.topMargin: 10
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 19
        text: "Pulse"
    }

    Text {
        id: heartRateText
        anchors.left: root.left
        anchors.top: pulseText.bottom
        anchors.topMargin: 10
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 19
        text: "heartRate"
    }

    Text {
        id: temperature
        anchors.left: root.left
        anchors.top: heartRateText.bottom
        anchors.topMargin: 10
        color: "#000000"
        font.family: "Open Sans"
        font.pointSize: 19
        text: "Temperature"
    }

    Rectangle {
        height: 4
        anchors.left: root.left
        anchors.leftMargin: 170
        anchors.right: pressureButton.left
        anchors.rightMargin: 15
        anchors.verticalCenter: pressureText.verticalCenter
        color: pressureColor
    }

    Rectangle {
        height: 4
        anchors.left: root.left
        anchors.leftMargin: 170
        anchors.right: pulseButton.left
        anchors.rightMargin: 15
        anchors.verticalCenter: pulseText.verticalCenter
        color: pulseColor
    }

    Rectangle {
        height: 4
        anchors.left: root.left
        anchors.leftMargin: 170
        anchors.right: heartRateButton.left
        anchors.rightMargin: 15
        anchors.verticalCenter: heartRateText.verticalCenter
        color: heartRateColor
    }

    Rectangle {
        height: 4
        anchors.left: root.left
        anchors.leftMargin: 170
        anchors.right: temperatureButton.left
        anchors.rightMargin: 15
        anchors.verticalCenter: temperature.verticalCenter
        color: temperatureColor
    }

    CheckBox {
        id: pressureButton
        buttonEnabled: false
        anchors.verticalCenter: pressureText.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: 40
    }

    CheckBox {
        id: pulseButton
        buttonEnabled: false
        anchors.verticalCenter: pulseText.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: 40
    }

    CheckBox {
        id: heartRateButton
        buttonEnabled: true
        anchors.verticalCenter: heartRateText.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: 40
    }

    CheckBox {
        id: temperatureButton
        buttonEnabled: true
        anchors.verticalCenter: temperature.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: 40
    }
}
