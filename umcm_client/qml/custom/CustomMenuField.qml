import QtQuick 2.12
import QtQuick.Layouts 1.12

/*!
 * \qmltype CustomMenuField
 * \brief Поле ввода, аналогичное текстовому полю, но которое открывает раскрывающееся меню.
 */
Item {
    id: __field

    implicitHeight: hasHelperText ? __helperTextLabel.y + __helperTextLabel.height + 4 : __underline.y + 8
    implicitWidth: __spinBoxContents.implicitWidth

    activeFocusOnTab: true

    property color accentColor: '#2196F3'
    property color errorColor: '#F44336'

    property alias model: __listView.model
    property alias menu: __menu

    property string textRole

    readonly property string selectedText: (__listView.currentItem) ? __listView.currentItem.text : ''

    property alias selectedIndex: __listView.currentIndex
    property int maxVisibleItems: 4

    property alias placeholderText: __fieldPlaceholder.text
    property alias helperText: __helperTextLabel.text

    property bool floatingLabel: false
    property bool hasError: false
    property bool hasHelperText: helperText.length > 0

    property alias textColor: __label.color
    property alias iconColor: __dropDownIcon.color

    readonly property rect inputRect: Qt.rect (__spinBox.x, __spinBox.y, __spinBox.width, __spinBox.height)

    signal itemSelected (int index)
    signal clicked ()

    property int leftMargin: 0
    property int rightMargin: 0
    property alias underlineVisible: __underline.visible

    readonly property color hintColor: Qt.rgba(0, 0, 0, 0.38)

    CustomInk {
        anchors.fill: parent

        onClicked: {
            if (model.count > 1) {
                __listView.positionViewAtIndex(__listView.currentIndex, ListView.Center)
                __menu.open(__label, -leftMargin, -16);
            }
            __field.clicked();
        }
    }

    Item {
        id: __spinBox
        height: 24
        width: parent.width

        y: {
            if (!floatingLabel)
                return 16;
            else if (!hasHelperText)
                return 20;
            else
                return 14; //28
        }

        RowLayout {
            id: __spinBoxContents
            height: parent.height
            width: parent.width + 5

            CustomLabel {
                id: __label
                text: (__listView.currentItem) ? __listView.currentItem.text : ''
                fontStyle: 'subtitle1'
                elide: Text.ElideRight

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                Layout.leftMargin: leftMargin
            }

            CustomIcon {
                id: __dropDownIcon
                name: 'navigation/arrow_drop_down'
                size: 24

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                Layout.rightMargin: rightMargin
            }
        }

        CustomDropdown {
            id: __menu
            anchor: Item.TopLeft
            width: __spinBox.width

            /*
             * Если количество элементов больше, чем максимальное, отобразим дополнительный элемент,
             * чтобы было ясно, что пользователь может прокручивать
             */
            height: Math.min(maxVisibleItems * 48 + 24, __listView.contentHeight)

            ListView {
                id: __listView
                width: __menu.width
                height: count > 0 ? __menu.height : 0
                interactive: true
                clip: true

                delegate: CustomStandardItem {
                    id: __delegateItem
                    text: textRole ? model[textRole] : modelData
                    backgroundColor: 'white'

                    onClicked: {
                        itemSelected(index)
                        __listView.currentIndex = index
                        __menu.close()
                    }
                }
            }

            CustomScrollIndicator {
                flickableItem: __listView
            }
        }
    }

    CustomLabel {
        id: __fieldPlaceholder
        text: __field.placeholderText
        visible: floatingLabel
        font.pixelSize: 12
        anchors.bottom: __spinBox.top
        anchors.bottomMargin: 8
        color: hintColor
    }

    Rectangle {
        id: __underline
        color: __field.hasError ? __field.errorColor : __field.activeFocus ? __field.accentColor : hintColor
        height: __field.activeFocus ? 2 : 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: __spinBox.bottom
        anchors.topMargin: 8

        Behavior on height { NumberAnimation { duration: 200 } }
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    CustomLabel {
        id: __helperTextLabel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: __underline.top
        anchors.topMargin: 4
        visible: hasHelperText
        font.pixelSize: 12
        color: __field.hasError ? __field.errorColor : Qt.darker(hintColor)

        Behavior on color { ColorAnimation { duration: 200 } }
    }
}
