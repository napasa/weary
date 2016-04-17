import QtQuick 2.0

Rectangle {
    id:sibling
   // color: "transparent"
    property alias labelText: label.text
    property alias inputText: input.text
    signal clickMSG
    width: 500
    height: 25
    anchors.left: parent.left
    anchors.margins: 10
    anchors.leftMargin: 20
    Text{
        id:label
        anchors.left:parent.left
        font.pixelSize: 20
        width:120
    }
    TextInput{
        id:input
        width: 300
        height: 25
        anchors.left: label.right
        anchors.leftMargin: 5
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        color: "#14aaff"
        text: "user01"
        onFocusChanged: {
            if(focus===true)
                rectangle1.color="red"
            else
                rectangle1.color= "#14aaff"
        }
        Rectangle {
            id: rectangle1
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            color: "#14aaff"
            radius: 2
            opacity: 0.3
            border.width: 2
            border.color: "#898989"
        }
    }
}

