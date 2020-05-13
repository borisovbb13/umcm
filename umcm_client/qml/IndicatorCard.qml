import QtQuick 2.12
import UMCM 0.1

Item {
    id: __card

    readonly property color hintColor: Qt.rgba(0, 0, 0, 0.38)
    property alias valueColor: __valueLabel.color
    property int precision: 0

    signal clicked (int _channel)

    CustomView {
        id: __oneIndicatorView
        elevation: 1
        border.color: 'transparent'
        radius: 2

        anchors {
            fill: parent
            margins: 4
        }

        CustomLabel {
            id: __channelLabel
            fontStyle: 'caption'
            text: qsTr('Channel ') + model.channel
            color: hintColor

            anchors {
                top: parent.top
                topMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
        }

        CustomLabel {
            id: __valueLabel
            fontStyle: 'h6'
            text: model.value.toFixed(precision).toString()

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        CustomLabel {
            id: __rangeLabel
            fontStyle: 'caption'
            color: hintColor
            text: ranges[model.range]

            anchors {
                bottom: parent.bottom
                bottomMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle {
            id: __stateIndicator
            width: 10
            height: width
            radius: width / 2

            color: {
                if (model.state === ClientHelper.ErrorState)
                    return '#FF5722';
                else if (model.state === ClientHelper.IddleState)
                    return '#9FA8DA';
                else if (model.state === ClientHelper.BusyState)
                    return '#BA68C8';
                else if (model.state === ClientHelper.MeasureState)
                    return '#4DB6AC';
                else
                    return '#E0E0E0'
            }

            anchors {
                top: parent.top
                topMargin: 4
                right: parent.right
                rightMargin: 4
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: __card.clicked(model.channel)
        }
    }
}
