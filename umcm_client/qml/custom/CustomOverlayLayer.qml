import QtQuick 2.12

/*!
 * \qmltype CustomOverlayLayer
 * \brief Предоставляет слой для отображения всплывающих окон и других элементов наложения.
 */
Rectangle {
    id: __overlayLayer
    objectName: 'overlayLayer'

    anchors.fill: parent

    property Item currentOverlay
    color: 'transparent'

    onEnabledChanged: {
        if (!enabled && __overlayLayer.currentOverlay != null)
            __overlayLayer.currentOverlay.close()
    }

    onWidthChanged: closeIfNecessary()
    onHeightChanged: closeIfNecessary()

    states: State {
        name: 'ShowState'
        when: __overlayLayer.currentOverlay != null

        PropertyChanges {
            target: __overlayLayer
            color: currentOverlay.overlayColor
        }
    }

    transitions: Transition {
        ColorAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    function closeIfNecessary() {
        if (__overlayLayer.currentOverlay != null && __overlayLayer.currentOverlay.closeOnResize)
            __overlayLayer.currentOverlay.close()
    }

    MouseArea {
        anchors.fill: parent
        enabled: __overlayLayer.currentOverlay != null &&
                __overlayLayer.currentOverlay.globalMouseAreaEnabled
        hoverEnabled: enabled

        onWheel: wheel.accepted = true

        onClicked: {
            if (__overlayLayer.currentOverlay.dismissOnTap)
                __overlayLayer.currentOverlay.close()
        }
    }
}
