import QtQuick 2.12

/*!
 * \qmltype CustomScrollIndicator
 * \brief Индикатор прокрутки для списков и показаний.
 */
Item {
    id: root

    property Flickable flickableItem
    property int orientation: Qt.Vertical
    property int thickness: 5
    property bool moving: flickableItem.moving
    property bool allwaysVisible: false

    width: thickness
    height: thickness
    clip: true
    smooth: true
    visible: orientation === Qt.Vertical ? flickableItem.contentHeight > flickableItem.height
                                         : flickableItem.contentWidth > flickableItem.width

    anchors {
        top: orientation === Qt.Vertical ? flickableItem.top : undefined
        bottom: flickableItem.bottom
        left: orientation === Qt.Horizontal ? flickableItem.left : undefined
        right: flickableItem.right
        margins: 2
    }

    Component.onCompleted: if (!allwaysVisible) __hideAnimation.start()

    onMovingChanged: {
        if (allwaysVisible)
            return;

        if (moving) {
            __hideAnimation.stop();
            __showAnimation.start();
        } else {
            __hideAnimation.start();
            __showAnimation.stop();
        }
    }

    NumberAnimation {
        id: __showAnimation
        target: __scrollBar
        property: 'opacity'
        to: 0.3
        duration: 200
        easing.type: Easing.InOutQuad
    }

    SequentialAnimation {
        id: __hideAnimation

        NumberAnimation {
            duration: 500
        }

        NumberAnimation {
            target: __scrollBar
            property: 'opacity'
            to: 0
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    onOrientationChanged: {
        if (orientation === Qt.Vertical)
            width = thickness;
        else
            height = thickness;
    }

    Rectangle {
        id: __scrollBar

        property int length: orientation === Qt.Vertical ? root.height : root.width;
        property int targetLength: orientation === Qt.Vertical ? flickableItem.height : flickableItem.width;
        property int contentStart: orientation === Qt.Vertical ? flickableItem.contentY : flickableItem.contentX;
        property int contentLength: orientation === Qt.Vertical ? flickableItem.contentHeight : flickableItem.contentWidth;
        property int start: Math.max (0, length * contentStart/contentLength);
        property int end: Math.min (length, length * (contentStart + targetLength)/contentLength)

        color: 'black'
        opacity: 0.3
        radius: thickness / 2
        width: Math.max (orientation === Qt.Horizontal ? end - start : 0, thickness)
        height: Math.max (orientation === Qt.Vertical ? end - start : 0, thickness)
        x: orientation === Qt.Horizontal ? start : 0
        y: orientation === Qt.Vertical ? start : 0
    }
}
