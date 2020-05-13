import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    property alias source: __mask.source

    Rectangle {
        id: __circleMask
        anchors.fill: parent
        smooth: true
        visible: false
        radius: Math.max(width/2, height/2)
    }

    OpacityMask {
        id: __mask
        anchors.fill: parent
        maskSource: __circleMask
    }
}
