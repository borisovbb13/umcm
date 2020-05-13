import QtQuick 2.12

/*!
 * \qmltype CustomDivider
 * \brief Разделитель, делящий контент.
 */
Item {
    height: vertical ? parent.height : (thin ? 1 : 8)
    width: vertical ? (thin ? 1 : 8) : parent.width

    anchors {
        left:   vertical ? undefined     : parent.left
        right:  vertical ? undefined     : parent.right
        top:    vertical ? parent.top    : undefined
        bottom: vertical ? parent.bottom : undefined
    }

    property bool  vertical: false
    property bool  thin: false
    property alias color: __rectangle.color

    Rectangle {
        id: __rectangle
        width: vertical ? 1 : parent.width
        height: vertical ? parent.height : 1
        color: Qt.rgba(0, 0, 0, 0.12)
    }
}
