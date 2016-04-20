import QtQuick 2.0

Text {
    id: button
    width: 120
    height: 36
    color: "#14aaff"
    text: qsTr("register")
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    anchors.verticalCenterOffset: 0
    font.pixelSize: 26
    property alias mouseEnabled : mouse.enabled
    property alias rectRadius: rectangle3.radius
    signal btnClicked
    MouseArea {
        id:mouse
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onEnabledChanged: {
            if(enabled === false){
                rectangle3.color = "#040404"
            }
            else if(enabled === true){
                rectangle3.color = "#14aaff"
            }
        }
        onClicked: {
            button.btnClicked()
        }
        onPressed: {
            if(enabled === true)
                rectangle3.color = "red"
        }
        onReleased: {
            if(enabled === false){
                rectangle3.color = "#040404"
            }
            else if(enabled === true){
                rectangle3.color = "#14aaff"
            }
        }
    }

    Rectangle {
        id: rectangle3
        anchors.fill: parent
        radius: 2
        opacity: 0.3
        border.color: "#898989"
        border.width: 3
        color : "#14aaff"
    }
}

