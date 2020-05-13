import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.12

/*!
 * \qmltype CustomStandardItem
 * \brief Простой элемент списка с одной строкой текста и необязательными первичными и вторичными действиями.
 */
CustomBaseItem {
    id: __listItem
    implicitHeight: 48
    height: 48
    dividerInset: __actionItem.visible ? __listItem.height : 0
    interactive: __contentItem.children.length === 0

    property alias text: __label.text
    property alias valueText: __valueLabel.text

    property alias action: __actionItem.children
    property alias iconName: __icon.name
    property alias secondaryItem: __secondaryItem.children
    property alias content: __contentItem.children

    property alias itemRow: __row
    property alias itemLabel: __label
    property alias itemValueLabel: __valueLabel

    property alias textColor: __label.color
    property alias iconColor: __icon.color

    implicitWidth: {
        var _width = __listItem.margins * 2;

        if (__actionItem.visible)
            _width += __actionItem.width + __row.spacing;

        if (__contentItem.visible)
            _width += __contentItem.implicitWidth + __row.spacing;
        else
            _width += __label.implicitWidth + __row.spacing;

        if (__valueLabel.visible)
            _width += __valueLabel.width + __row.spacing;

        if (__secondaryItem.visible)
            _width += __secondaryItem.width + __row.spacing;

        return _width
    }

    RowLayout {
        id: __row
        anchors.fill: parent
        anchors.leftMargin: __listItem.margins
        anchors.rightMargin: __listItem.margins
        spacing: 12

        Item {
            id: __actionItem
            Layout.preferredWidth: 24
            Layout.preferredHeight: width
            Layout.alignment: Qt.AlignCenter
            visible: children.length > 1 || __icon.valid

            CustomIcon {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                visible: valid
                color: __listItem.selected ? '#2196F3' : Qt.rgba(0, 0, 0, 0.54)
                size: 24
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: parent.height

            Item {
                id: __contentItem
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height
                visible: children.length > 0
            }

            CustomLabel {
                id: __label
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                elide: Text.ElideRight
                fontStyle: 'subtitle1'
                color: __listItem.selected ? '#2196F3' : Qt.rgba(0, 0, 0, 0.87)
                visible: !__contentItem.visible
            }
        }

        CustomLabel {
            id: __valueLabel
            Layout.alignment: Qt.AlignVCenter
            color: Qt.rgba(0, 0, 0, 0.54)
            elide: Text.ElideRight
            fontStyle: 'body1'
            visible: text !== ''
        }

        Item {
            id: __secondaryItem
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: parent.height
            visible: children.length > 0
        }
    }
}
