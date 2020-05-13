import QtQuick 2.12

/*!
 * \qmltype CustomInk
 * \brief Представляет анимацию пульсации, используемую в кнопках и многих других компонентах.
 */
MouseArea {
    id: view
    clip: true
    hoverEnabled: true
    z: 2

    property int startRadius: circular ? width/10 : width/6
    property int endRadius

    property Item lastCircle
    property color color: Qt.rgba(0,0,0,0.1)

    property bool circular: false
    property bool centered: false

    property int focusWidth: width - 32
    property bool focused
    property color focusColor: 'transparent'

    property bool showFocus: true

    Rectangle {
        id: __focusBackground
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.1)
        opacity: showFocus && focused ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
    }

    Rectangle {
        id: __focusCircle
        anchors.centerIn: parent
        width: focused ? (focusedState ? focusWidth : Math.min(parent.width - 8, focusWidth + 12)) : parent.width/5
        height: width
        radius: width/2
        opacity: showFocus && focused ? 1 : 0
        color: focusColor.a === 0 ? Qt.rgba(1, 1, 1, 0.4) : focusColor

        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
        Behavior on width { NumberAnimation { duration: __focusTimer.interval; } }

        property bool focusedState

        Timer {
            id: __focusTimer
            running: focused
            repeat: true
            interval: 800
            onTriggered: __focusCircle.focusedState = !__focusCircle.focusedState
        }
    }

    Component {
        id: __tapCircle

        Item {
            id: __circleItem
            anchors.fill: parent

            property bool done
            property real circleX
            property real circleY
            property bool closed

            Item {
                id: __circleParent
                anchors.fill: parent
                visible: !circular

                Rectangle {
                    id: __circleRectangle
                    x: __circleItem.circleX - radius
                    y: __circleItem.circleY - radius
                    width: radius * 2
                    height: radius * 2
                    opacity: 0
                    color: view.color

                    NumberAnimation {
                        id: __fillSizeAnimation
                        running: true
                        target: __circleRectangle; property: 'radius'; duration: 500;
                        from: startRadius; to: endRadius; easing.type: Easing.InOutQuad
                        onStopped: { if (done) showFocus = true }
                    }

                    NumberAnimation {
                        id: __fillOpacityAnimation
                        running: true
                        target: __circleRectangle
                        property: 'opacity'
                        duration: 300
                        from: 0
                        to: 1
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        id: __fadeAnimation
                        target: __circleRectangle
                        property: 'opacity'
                        duration: 300
                        from: 1
                        to: 0
                        easing.type: Easing.InOutQuad
                    }

                    SequentialAnimation {
                        id: __closeAnimation

                        NumberAnimation {
                            target: __circleRectangle
                            property: 'opacity'
                            duration: 250
                            to: 1
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: __circleRectangle
                            property: 'opacity'
                            duration: 250
                            from: 1
                            to: 0
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            CustomCircleMask {
                anchors.fill: parent
                source: __circleParent
                visible: circular
            }

            function removeCircle ()
            {
                done = true

                if (__fillSizeAnimation.running)
                {
                    __fillOpacityAnimation.stop()
                    __closeAnimation.start()
                    __circleItem.destroy(500);
                }
                else
                {
                    showFocus = true
                    __fadeAnimation.start();
                    __circleItem.destroy(300);
                }
            }
        }
    }

    onPressed: { createTapCircle (mouse.x, mouse.y) }
    onCanceled: { lastCircle.removeCircle(); }
    onReleased: { lastCircle.removeCircle(); }

    function createTapCircle (x, y)
    {
        endRadius = centered ? width/2 : radius(x, y)
        showFocus = false
        lastCircle = __tapCircle.createObject (view, { 'circleX': centered ? width/2 : x, 'circleY': centered ? height/2 : y });
    }

    function radius (x, y)
    {
        var dist1 = Math.max(dist(x, y, 0, 0), dist(x, y, width, height))
        var dist2 = Math.max(dist(x, y, width, 0), dist(x, y, 0, height))

        return Math.max(dist1, dist2)
    }

    function dist (x1, y1, x2, y2)
    {
        var xs = 0;
        var ys = 0;

        xs = x2 - x1;
        xs = xs * xs;

        ys = y2 - y1;
        ys = ys * ys;

        return Math.sqrt( xs + ys );
    }
}
