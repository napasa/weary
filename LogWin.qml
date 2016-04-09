import QtQuick 2.0
import IOs 1.0
Rectangle {
    id: firstwin
    width: 300
    height: 320
    color: "#7f1230"
    radius: 15
    scale: 1
    transformOrigin: Item.BottomLeft
    rotation: 0
    clip: true
    border.width: 10
    signal createView(url url)
    signal exited
    signal log
    signal transferAc(string Ac)
    onCreateView: firstwin.log()
    onLog:transferAc(accountenter.text)

    function status(){
       console.log("serv had sent message");
       var statu = toconnect.text;
       console.log(statu);
       console.log(statu[0]);
       if(statu[0] == 1){
         if(statu[1] == 1){
           refer.text = "Register Successfully! Use it when next log";
         }
         else if(statu[1] == 0)
           refer.text = "You accounts registered. Try A New!";
       }
       else if(statu[0] == 2){
         if(statu[1] == 1){
           //firstwin.transferAc(accountenter.text);
           console.log("log successfully");
           refer.text = "Log Successfully! Enjoy it!"
          // firstwin.log();
           firstwin.createView("qrc:/demos/stocqt/wearyMaster.qml");
           //toconnect.unconnectHost();
         }
         else if(statu[1] == 0){
           console.log("log failurely");
           refer.text = "You entered error account or password,Try Again!";
         }
       }
       else;
    }

    Clien {
        id: toconnect
        onTextChanged:status()
    }

    function tologOrRegister(order) {
                     console.log("MouseArea is clicked");
                     var ac = accountenter.text;
                     var pwd = pwdenter.text;
                     var errch = 0;
                     for(var i=0;i<ac.length;i++){
                         if(ac[i]<'0' || '9'<ac[i]<'A' || 'Z'<ac[i]<'a' || ac[i]>'z'){
                             errch = 1;
                             break;
                         }
                     }
                     if(errch === 0){
                         for(i=0;i<pwd.length;i++){
                             if(ac[i]<'0' || '9'<ac[i]<'A' || 'Z'<ac[i]<'a' || ac[i]>'z'){
                                 errch = 1;
                                 break;
                             }
                         }
                     }
                     if(errch === 1)
                         refer.text = "Account or password has illegal character.reenter again! "
                     else{
                         refer.text = "connecting server to login";
                         var aclen = ac.length;
                         var pwdlen = pwd.length;
                         var len = (4 + aclen + pwdlen).toString();
                         len = "00" + len;
                         if(aclen.toString().length===1)
                             aclen="0"+aclen.toString();
                         if(pwdlen.toString().length===1)
                             pwdlen="0"+pwdlen.toString();
                         toconnect.connectHost();
                         toconnect.construction = order+len+aclen+ac+pwdlen+pwd;
                         console.log(order+len+aclen+ac+pwdlen+pwd);
                         toconnect.writeMessage();
                     }
                 }
    TextInput {
        id: accountenter
        x: 160
        y: 59
        width: 236
        height: 31
        color: "#14aaff"
        text: "user01"
        transformOrigin: Item.Center
        echoMode: TextInput.Normal
        z: 1
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 26

        Rectangle {
            id: rectangle1
            x: 0
            y: 0
            width: 236
            height: 31
            color: "#14aaff"
            radius: 2
            opacity: 0.3
            border.width: 2
            border.color: "#898989"
        }
    }

    Text {
        id: account
        x: 82
        y: 29
        width: 236
        height: 24
        color: "#14aaff"
        text: qsTr("Accounts:")
        z: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.right: accountenter.right
        anchors.bottom: accountenter.top
        anchors.bottomMargin: 6
        anchors.left: accountenter.left
        font.pixelSize: 12
    }

    Text {
        id: password
        x: 82
        y: 99
        width: 236
        height: 30
        color: "#14aaff"
        text: qsTr("Password:")
        anchors.horizontalCenterOffset: 0
        z: 1
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
    }

    TextInput {
        id: pwdenter
        x: 82
        y: 139
        width: 236
        height: 39
        color: "#14aaff"
        text: "pwd01"
        //echoMode: TextInput.Password
        z: 1
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenterOffset: -1
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 34

        Rectangle {
            id: rectangle2
            x: 0
            y: 0
            width: 236
            height: 39
            color: "#14aaff"
            radius: 2
            opacity: 0.3
            border.width: 2
            border.color: "#898989"
        }
    }

    Text {
        id: logbutton
        x: 30
        y: 226
        width: 106
        height: 36
        color: "#14aaff"
        text: qsTr("log")
        z: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 26
        MouseArea {
            id: logmouse
            x: 0
            y: 0
            width: 106
            height: 36
            z: 1
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            acceptedButtons: Qt.LeftButton
            enabled: accountenter.text.length > 4 && pwdenter.text.length > 4
                     && accountenter.text.length < 8 && pwdenter.text.length < 8
            onEnabledChanged: {
                if(enabled === false){
                    refer.text = "Account and Password consist of chracter among A~Z,a~z,0~9"
                    rectangle4.color = "#040404"
                }
                else if(enabled === true){
                    refer.text = "Click log button to log or register"
                    rectangle4.color = "#14aaff"
                }
            }
            onClicked: firstwin.tologOrRegister("02");
        }

        Rectangle {
            id: rectangle4
            width: 106
            height: 36
            opacity: 0.3
            border.color: "#898989"
            border.width: 3
        }
    }

    Text {
        id: regbutton
        x: 162
        y: 225
        width: 106
        height: 36
        color: "#14aaff"
        text: qsTr("register")
        z: 2
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: logbutton.verticalCenter
        font.pixelSize: 26
        MouseArea {
            id: regmouse
            x: 0
            y: 0
            width: 106
            height: 36
            z: 1
            enabled: accountenter.text.length > 4 && pwdenter.text.length > 4
                     && accountenter.text.length < 8 && pwdenter.text.length < 8
            onEnabledChanged: {
                if(enabled === false){
                    rectangle4.color = "#040404"
                }
                else if(enabled === true){
                    rectangle4.color = "#14aaff"
                }
            }
            onClicked:firstwin.tologOrRegister("01");
        }

        Rectangle {
            id: rectangle3
            width: 106
            height: 36
            radius: 2
            opacity: 0.3
            border.width: 2
            border.color: "#898989"
        }
    }

    Text {
        id: exit
        x: 90
        y: 269
        width: 106
        height: 36
        color: "#14aaff"
        text: qsTr("Exit")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 25

        Rectangle {
            id: rectangle5
            width: 106
            height: 36
            color: "#14aaff"
            opacity: 0.2
        }

        MouseArea {
            id: exitArea
            width: 106
            height: 36
            onClicked: firstwin.exited()
        }
    }

    Text {
        id: refer
        x: 30
        y: 184
        width: 238
        height: 35
        wrapMode: Text.WordWrap
        font.underline: true
        style: Text.Normal
        textFormat: Text.AutoText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 12
    }
}

