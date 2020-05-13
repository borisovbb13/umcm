import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

/*!
 * \qmltype CustomView
 * \brief Компонент основного вида
 */
Item {
    id: __item
    width: 100
    height: 62

    property int elevation: 0
    property real radius: 0
    property string style: 'default'

    property color backgroundColor: elevation > 0 ? 'white' : 'transparent'
    property color tintColor: 'transparent'

    property alias border: __rect.border

    property bool fullWidth
    property bool fullHeight

    property alias clipContent: __rect.clip
    default property alias contentData: __rect.data
    property bool elevationInverted: false

    property var topShadow: [
        { 'opacity': 0.00, 'offset':  0, 'blur':  0.0 },
        { 'opacity': 0.12, 'offset':  1, 'blur':  1.5 },
        { 'opacity': 0.16, 'offset':  3, 'blur':  3.0 },
        { 'opacity': 0.19, 'offset': 10, 'blur': 10.0 },
        { 'opacity': 0.25, 'offset': 14, 'blur': 14.0 },
        { 'opacity': 0.30, 'offset': 19, 'blur': 19.0 }
    ]

    property var bottomShadow: [
        { 'opacity': 0.00, 'offset':  0, 'blur': 0 },
        { 'opacity': 0.24, 'offset':  1, 'blur': 1 },
        { 'opacity': 0.23, 'offset':  3, 'blur': 3 },
        { 'opacity': 0.23, 'offset':  6, 'blur': 3 },
        { 'opacity': 0.22, 'offset': 10, 'blur': 5 },
        { 'opacity': 0.22, 'offset': 15, 'blur': 6 }
    ]

    RectangularGlow {
        property var elevationInfo: bottomShadow[Math.min(elevation, 5)]
        property real horizontalShadowOffset: elevationInfo.offset * Math.sin((2 * Math.PI) * (parent.rotation / 360.0))
        property real verticalShadowOffset: elevationInfo.offset * Math.cos((2 * Math.PI) * (parent.rotation / 360.0))

        anchors.centerIn: parent
        width: parent.width + (fullWidth ? 10 : 0)
        height: parent.height + (fullHeight ? 20 : 0)
        anchors.horizontalCenterOffset: horizontalShadowOffset * (elevationInverted ? -1 : 1)
        anchors.verticalCenterOffset: verticalShadowOffset * (elevationInverted ? -1 : 1)
        glowRadius: elevationInfo.blur
        opacity: elevationInfo.opacity
        spread: 0.05
        color: '#000000'
        cornerRadius: __item.radius + glowRadius * 2.5
        //visible: parent.opacity == 1
    }

    RectangularGlow {
        property var elevationInfo: topShadow[Math.min(elevation, 5)]
        property real horizontalShadowOffset: elevationInfo.offset * Math.sin((2 * Math.PI) * (parent.rotation / 360.0))
        property real verticalShadowOffset: elevationInfo.offset * Math.cos((2 * Math.PI) * (parent.rotation / 360.0))

        anchors.centerIn: parent
        width: parent.width + (fullWidth ? 10 : 0)
        height: parent.height + (fullHeight ? 20 : 0)
        anchors.horizontalCenterOffset: horizontalShadowOffset * (elevationInverted ? -1 : 1)
        anchors.verticalCenterOffset: verticalShadowOffset * (elevationInverted ? -1 : 1)
        glowRadius: elevationInfo.blur
        opacity: elevationInfo.opacity
        spread: 0.05
        color: '#000000'
        cornerRadius: __item.radius + glowRadius * 2.5
        //visible: parent.opacity == 1
    }

    Rectangle {
        id: __rect
        anchors.fill: parent
        color: Qt.tint(backgroundColor, tintColor)
        radius: __item.radius
        antialiasing: parent.rotation || radius > 0 ? true : false
        clip: true

        Behavior on color { ColorAnimation { duration: 200 } }
    }
}
