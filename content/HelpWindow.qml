import QtQuick 2.0

    Rectangle {
        id: popupHelp
        z: 1000
        width: parent.width
        height: popupColumn.height + 16
        color: "transparent"
        property bool poppedUp: false
        property alias helpText: helpText.text
        onPoppedUpChanged: {
            if(poppedUp)
                color = "black"
            else
                color = "transparent"
        }

        property int downY: parent.height - (popupButton.height + 16)
        property int upY: parent.height - (popupColumn.height + 16)
        y: poppedUp ? upY : downY
        Behavior on y { NumberAnimation {}}

        Column {
            id: popupColumn
            y: 8
            spacing: 8
            width: parent.width
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                height: popupButton.height
                spacing: 8
                Text { text: "Help:"; font.pixelSize: 20; anchors.verticalCenter: parent.verticalCenter }
                SelectBtn {
                    id: popupButton
                    text: popupHelp.poppedUp ? "Hide" : "Show"
                    onBtnClicked: popupHelp.poppedUp = !popupHelp.poppedUp
                }
            }

            Rectangle {
                width: parent.width; height: helpText.implicitHeight+16
                color : "black"
                TextEdit {
                    id: helpText
                    anchors.fill: parent; anchors.margins: 5
                    readOnly: false
                    font.pixelSize: 14
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color:"white"
                    textFormat: Text.RichText
                }
            }
        }
    }


