import QtQuick 2.12
import QtQuick.Layouts 1.12

/*!
 * \qmltype CustomBaseItem
 * \brief Базовый класс для элементов списка.
 * \details Обеспечивает эффекты чернил, манипуляции с мышью/касанием и тонирование при наведении мыши.
 */
CustomView {
    id: __listItem

    anchors.left: parent ? parent.left : undefined
    anchors.right: parent ? parent.right : undefined

    property int margins: 16
    property bool selected
    property bool interactive: true
    property int dividerInset: 0
    property bool showDivider: false

    signal clicked()
    signal pressAndHold()

    opacity: __listItem.enabled ? 1 : 0.6
    tintColor: __listItem.selected ? Qt.rgba(0, 0, 0, 0.05) : (__ink.containsMouse ? Qt.rgba(0, 0, 0, 0.03) : Qt.rgba(0, 0, 0, 0))

    CustomDivider {
        id: __divider
        visible: __listItem.showDivider
        thin: true

        anchors {
            bottom: parent.bottom
            leftMargin: __listItem.dividerInset
        }
    }

    CustomInk {
        id: __ink
        anchors.fill: parent
        enabled: __listItem.interactive && __listItem.enabled
        z: -1

        onClicked: __listItem.clicked()
        onPressAndHold: __listItem.pressAndHold()
    }
}
