import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

Window {
    id: __window
    visible: true
    minimumWidth: 800
    minimumHeight: 600
    width: 800
    height: 600
    title: qsTr("Client")
    color: '#CFD8DC'

    readonly property int channelsCount: indicatorsModel.rowCount()

    // Индикация каналов
    GridView {
        id: __indicatorsView

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: __sidebar.left
            margins: 4
        }

        cellWidth: __indicatorsView.width * 0.25
        cellHeight: 80

        Component {
            id: __indicatorDelegate

            IndicatorCard {
                width: __indicatorsView.cellWidth
                height: __indicatorsView.cellHeight
                valueColor: model.channel === __sidebar.channelSelectedIndex ? '#2196F3' : Qt.rgba(0, 0, 0, 0.87)

                onClicked: {
                    __sidebar.channelSelectedIndex = _channel;
                }
            }
        }

        model: indicatorsModel
        delegate: __indicatorDelegate
        focus: true
    }

    // Полоса прокрутки для индикации каналов
    CustomScrollIndicator {
        flickableItem: __indicatorsView
        anchors.rightMargin: -3
    }

    // Правая боковая панель
    Sidebar {
        id: __sidebar
    }

    // Слой для элементов выше основного контента
    CustomOverlayLayer {
        id: __overlayLayer
    }

    Connections {
        target: clientHelper

        onUpdateRange: indicatorsModel.updateRange(_channel, _range)
        onUpdateValue: indicatorsModel.updateValue(_channel, _value)
        onUpdateState: indicatorsModel.updateState(_channel, _state)
    }
}
