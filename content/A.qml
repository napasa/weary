import QtQuick 2.0

Item{
 id:_a
 width:200
 height:200
 Rectangle{
     anchors.fill: parent
     color:"red"
 }
 Component.onCompleted: console.log("A.qml")
 function showB(){
   var component = Qt.createComponent("B.qml");

        if (component.status == Component.Ready) {
            var bQml = component.createObject(_a);
            bQml.xClicked.connect(doSomething);// 实现两个qml组件之间的通信
        }
 }
 function doSomething(msg){
   console.log(msg+"do something");
 }
 MouseArea{
  anchors.fill :parent
  onClicked:showB()
 }
}
