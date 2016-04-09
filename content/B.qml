import QtQuick 2.0


Item{
 id:_b
 width:100
 height:100
 signal xClicked(string msg)
 MouseArea{
   anchors.fill:parent
   onClicked:{
    _b.xClicked("test")
    _b.destroy()
   }
 }
 Rectangle{
     anchors.fill: parent
     color: "blue"
 }
}
