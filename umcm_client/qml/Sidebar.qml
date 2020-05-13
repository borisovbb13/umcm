import QtQuick 2.12
import UMCM 0.1

CustomSidebar {
    id: __sidebar
    width: 200
    autoFlick: false
    focus: false
    elevation: 1
    borderWidth: 0
    marginDisable: true
    mode: 'right'
    backgroundColor: '#ECEFF1'

    property alias channelSelectedIndex: __channelField.selectedIndex
    property alias rangeSelectedIndex: __rangeField.selectedIndex

    contents: Item {
        anchors.fill: parent

        CustomMenuField {
            id: __channelField
            maxVisibleItems: 6
            floatingLabel: true
            placeholderText: qsTr('Channel')
            model: ListModel { id: __channelsModel }

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 8
            }

            Component.onCompleted: {
                for (var i = 0; i < channelsCount; ++i)
                    __channelsModel.append({ 'name': qsTr('Channel ') + i });

                selectedIndex = 0;
            }
        }

        CustomMenuField {
            id: __rangeField
            maxVisibleItems: 4
            floatingLabel: true
            placeholderText: qsTr('Range for setting')
            model: ListModel { id: __rangesModel }

            anchors {
                top: __channelField.bottom
                left: parent.left
                right: parent.right
                margins: 8
            }

            Component.onCompleted: {
                for (var i = 0; i < ranges.length; ++i)
                    __rangesModel.append({ 'name': ranges[i] });

                selectedIndex = __rangesModel.count - 1;
            }
        }

        CustomDivider {
            anchors.bottom: __setRangeButton.top
        }

        CustomButton {
            id: __setRangeButton
            elevation: 1
            text: qsTr('Set Range')
            enabled: rangeSelectedIndex !== indicatorsModel.rangeAt(channelSelectedIndex)

            anchors {
                bottom: __getStatusButton.top
                left: parent.left
                right: parent.right
                margins: 8
            }

            onClicked: {
                clientHelper.sendRequest(ClientHelper.SetRange, channelSelectedIndex, rangeSelectedIndex)
            }
        }

        CustomButton {
            id: __getStatusButton
            elevation: 1
            text: qsTr('Get Status')
//            enabled: false

            anchors {
                bottom: __getResultButton.top
                left: parent.left
                right: parent.right
                margins: 8
            }

            onClicked: {
                clientHelper.sendRequest(ClientHelper.GetStatus, channelSelectedIndex)
            }
        }

        CustomButton {
            id: __getResultButton
            elevation: 1
            text: qsTr('Get Result')
//            enabled: false

            anchors {
                bottom: __measureDivider.top
                left: parent.left
                right: parent.right
                margins: 8
            }

            onClicked: {
                clientHelper.sendRequest(ClientHelper.GetResult, channelSelectedIndex)
            }
        }

        CustomDivider {
            id: __measureDivider
            anchors.bottom: __startButton.top
        }

        CustomButton {
            id: __startButton
            elevation: 1
            text: qsTr('Start Measure')

            anchors {
                bottom: __stopButton.top
                left: parent.left
                right: parent.right
                margins: 8
            }

            onClicked: {
                clientHelper.sendRequest(ClientHelper.StartMeasure, channelSelectedIndex)
            }
        }

        CustomButton {
            id: __stopButton
            elevation: 1
            text: qsTr('Stop Measure')
//            enabled: false

            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 8
            }

            onClicked: {
                clientHelper.sendRequest(ClientHelper.StopMeasure, channelSelectedIndex)
            }
        }
    }
}
