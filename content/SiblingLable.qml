import QtQuick 2.0

Rectangle {
    width: 40
    height: 20
    property  alias lableText: lable.text
    property alias infoText: info.text
    property alias lableSize: lable.font.pixelSize
    anchors.topMargin: 12
    Text {
        id:lable
        anchors.left: parent.left
        anchors.margins: 10
        font.pixelSize: 20
    }
    Text {
        id:info
        anchors.left: lable.left
        anchors.leftMargin: 140
        font.pixelSize: 20
        color: "#14aaff"
    }
}

