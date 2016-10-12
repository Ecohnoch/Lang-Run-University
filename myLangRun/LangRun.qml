import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import QtQuick 2.7
import File 1.0

Item {
    property string scene: "schoolGate"
    property string currentScene: "register"
    property string nextScene1: "shoppingStreet"
    property string nextScene2: ""
    property bool transing: true
//    property var data: JSON.parse(File.read(":/data.json"))


    Image{
        id: backScene
        scale: myScale
        source: "qrc:/image/bg/" + scene + ".jpg"
        transformOrigin: Image.TopLeft
    }
    function changeScene(s){
        var data = JSON.parse(File.read(":/data.json"))
        for (var key in data){
            if(s === key){
                hideButtons()
                mask.switchScene(function(){
                        scene = s; transing = false;
                        showButtons()
                    },
                    function(){
                        transing = true;
                    }
                )
                if(data[key][5].charAt(0) === 'n'){
                    npc1.mySource = "qrc:/npc/hutTelNanwang.png"
                    npc1.myText = "南望"
                    npc1.dlg = data[key][6]
                    vo.switchTo(data[key][5])
                }else if(data[key][5].charAt(0) === 'm'){
                    npc1.mySource = "qrc:/npc/hutTelMingmei2.png"
                    npc1.myText = "明美"
                    npc1.dlg = data[key][6]
                    vo.switchTo(data[key][5])
                }else if(data[key][5].charAt(0) === 'x'){
                    npc1.mySource = "qrc:/npc/dormTelCall.png"
                    npc1.myText = "星瑶"
                    npc1.dlg = data[key][6]
                    vo.switchTo(data[key][5])
                }

                changeMusic(s)
                nextScene1 = data[key][2];
                nextScene2 = data[key][3]
                currentScene = data[key][1];
                toCurrentScene.currentText = data[currentScene][4];
                if(nextScene1 != "") toNextScene1.nextScene1Text = data[nextScene1][4];
                if(nextScene2 != "") toNextScene2.nextScene2Text = data[nextScene2][4]
            }
        }
    }

    function changeMusic(s){
        if(s === "schoolGate")
            switchTo("DawnAndEveningInFoggyRain.mp3")
        else if(s === "houseLane")
            switchTo("Fireworks.mp3")
        else if(s === "beachRoad")
            switchTo("ThoseYears.mp3")
        else if(s === "observatory")
            switchTo("CourageAndAction.mp3")
    }

    // buttons

    FontLoader{id:fontHei; source:'qrc:/font/PingFangM.ttf'}
    Rectangle{
        id: toCurrentScene
        width: 100; height: 50
        x: 10; y: 425
        opacity: 0.6
        color: "steelblue"
        property string currentText : "教务楼"
        Text{
            anchors.centerIn: parent
            font.family: fontHei.name
            text: "<To " + toCurrentScene.currentText + ">"
        }
        MouseArea{
            anchors.fill: parent
            enabled: transing
            hoverEnabled: true
            onClicked:{
                changeScene(currentScene)
                console.log("you clicked toCurrentScene")
            }
            onEntered: parent.opacity = 0.7
            onExited: parent.opacity = 0.6
        }
    }

    Rectangle{
        id: toNextScene1
        width: 100; height: 50
        x: 490; y: 425
        opacity: 0.6
        color: "steelblue"
        visible: !(nextScene1 == "")
        property string nextScene1Text : "校门远处"
        Text{
            anchors.centerIn: parent
            font.family: fontHei.name
            text: "<To " + toNextScene1.nextScene1Text + ">"
        }
        MouseArea{
            id: next1
            anchors.fill: parent
            enabled: transing
            hoverEnabled: true
            onClicked: {
                changeScene(nextScene1)
                console.log("you clicked toNextScene1")
            }
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 0.6
        }
    }
    Rectangle{
        id: toNextScene2
        width: 100; height: 50
        x: 610; y:425
        opacity: 0.6
        color: "steelblue"
        visible: !(nextScene2 == "")

        property string nextScene2Text : "校门远处"
        Text{
            anchors.centerIn: parent
            font.family: fontHei.name
            text: "<To " + toNextScene2.nextScene2Text + ">"
        }
        MouseArea{
            anchors.fill: parent
            enabled: transing
            hoverEnabled: true
            onClicked:{
                changeScene(nextScene2)
                console.log("you clicked toNextScene2")
            }
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 0.6
        }
    }



    //npcs

    Rectangle{
        id: npc1
        width: 100; height: 100
        x: 610; y: 0
        color: '#00000000'
        opacity : 0
        property string mySource: "qrc:/npc/hutTelNanwang.png"
        property string myText: "南望"
        property string dlg: ""
        Image{
            anchors.fill: parent
            source: npc1.mySource
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log("You talk to NPC now")
            }
        }
        Text{
            anchors.top: npc1.bottom
            anchors.topMargin: 4
            x: parent.width/2; y: parent.height
            font.family: fontHei.name
            font.pixelSize: 14
            color: '#FFFFFFFF'
            text: npc1.myText
        }
    }
    Text{
        id: dlg
        opacity: 0
        anchors.right: npc1.left
        y: npc1.height/3
        font.family: fontHei.name
        font.pixelSize: 18
        color: 'black'
        text: npc1.dlg
    }



    //music
    Video{
        id: bgm
        volume: 0.7
        autoPlay: true
        source: "bgm/DawnAndEveningInFoggyRain.mp3"
        onStopped: {bgm.play()}
        NumberAnimation on volume{
            id: bgmFadeOut
            duration: 750; running: false
            property var myStopped
            onStopped:{if(myStopped) myStopped()}
        }
        function _switchTo(path){
            bgmFadeOut.myStopped = function(){
                bgm.source = "qrc:/bgm/" + path
                bgm.play()
            }
            bgmFadeOut.restart()
        }
    }
    function switchTo(path){
        bgm._switchTo(path)
    }

    Video{
        id: vo
        autoPlay: true
        source: ""
        function switchTo(path){
            vo.source = "qrc:/voice/" + path + ".mp3"
            vo.play()
        }
    }

    function hideButtons(){
        toCurrentScene.opacity = 0
        toNextScene1.opacity = 0
        toNextScene2.opacity = 0
        dlg.opacity = 0
        npc1.opacity = 0
    }
    function showButtons(s){
        toCurrentScene.opacity = 0.6
        toNextScene1.opacity = 0.6
        toNextScene2.opacity = 0.6
        dlg.opacity = 1
        npc1.opacity = 1
    }
}
