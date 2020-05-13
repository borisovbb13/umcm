import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: __control
    opacity: active ? 1.0 : 0.3

    property string name: ''
    property bool active: true
    property bool valid: __image.status === Image.Ready

    property color color: Qt.rgba(0, 0, 0, 0.54)
    property real size: 24

    property alias horizontalAlignment: __image.horizontalAlignment
    property alias verticalAlignment: __image.verticalAlignment

    width: size
    height: size

    Image {
        id: __image
        anchors.fill: parent
        visible: false
        source: name.length > 0 ? 'qrc:///' + name + '.svg' : ''
        mipmap: true
    }

    ColorOverlay {
        id: __overlay
        anchors.fill: parent
        source: __image
        color: __control.color
        cached: true
        visible: __image.source !== ''
        opacity: __control.color.a
    }

    onNameChanged: if (name.length > 0) __image.source = 'qrc:///' + name + '.svg'
    onSizeChanged: if (name.length > 0) __image.source = 'qrc:///' + name + '.svg'
}
