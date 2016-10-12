import QtQuick 2.7
import QtMultimedia 5.4

Item{
    id: mainItem
    width: 720; height: 480
    property real myScale: 720/2048
    LangRun {
        id: langrun
    }

    Rectangle{
        id: mask
        anchors.fill: parent
        color: "black"
        opacity: 0

        NumberAnimation on opacity {
            id: maskFadeIn
            property var myStopped; easing.type: Easing.InOutQuad
            running: false; duration: 750
            to: 1; onStopped: {if(myStopped) {myStopped(); maskFadeOut.restart()}}
        }

        NumberAnimation on opacity {
            id: maskFadeOut
            property var myStopped; easing.type: Easing.InOutQuad
            running: false; duration: 500
            to: 0; onStopped: {if(myStopped) myStopped()}
        }

        function switchScene(callback1, callback2){
            maskFadeIn.myStopped = callback1
            maskFadeOut.myStopped = callback2
            maskFadeIn.restart()
        }
    }


}
