import QtQuick 2.12
import QtQuick.Window 2.3

/*!
 * \qmltype CustomDropdown
 * \brief Выпадающее меню, которое может отображать разнообразный контент.
 */
CustomPopupBase {
    id: __dropdown

    default property alias contentData: __view.data
    property int anchor: Item.TopRight
    property alias internalView: __view

    visible: __view.opacity > 0
    closeOnResize: true

    function open (_caller, _offsetX, _offsetY) {
        lastFocusedItem = Window.activeFocusItem;
        parent = findRootChild (__dropdown, overlayLayer);

        if (!parent.enabled)
            return;

        if (parent.currentOverlay)
            parent.currentOverlay.close();

        if (typeof _offsetX === 'undefined') _offsetX = 0;
        if (typeof _offsetY === 'undefined') _offsetY = 0;

        var _position = _caller.mapToItem(__dropdown.parent, 0, 0);

        // Убедимся, что находимся в пределах окна, переходим, если нужно
        var __globalPos = _caller.mapToItem(null, 0, 0);
        var __root = findRoot(__dropdown);

        if (__internal.left)
            __dropdown.x = _position.x;
        else if (__internal.center)
            __dropdown.x = _caller.width / 2 - __dropdown.width / 2;
        else
            __dropdown.x = _position.x + _caller.width - __dropdown.width;

        if (__internal.top)
            __dropdown.y = _position.y;
        else if (__internal.center)
            __dropdown.y = _caller.height / 2 - __dropdown.height / 2;
        else
            __dropdown.y = _position.y + _caller.height - __dropdown.height;

        __dropdown.x += _offsetX;
        __dropdown.y += _offsetY;

        if(__dropdown.y + height > __root.height)
            __dropdown.y += -((__dropdown.y + height + 16) - __root.height);

        if(__dropdown.x + width > __root.width)
            __dropdown.x += -((__dropdown.x + width + 16) - __root.width);

        showing = true;
        parent.currentOverlay = __dropdown;

        opened();
    }

    QtObject {
        id: __internal

        property bool left   : __dropdown.anchor === Item.Left   || __dropdown.anchor === Item.TopLeft    || __dropdown.anchor === Item.BottomLeft
        property bool right  : __dropdown.anchor === Item.Right  || __dropdown.anchor === Item.TopRight   || __dropdown.anchor === Item.BottomRight
        property bool top    : __dropdown.anchor === Item.Top    || __dropdown.anchor === Item.TopLeft    || __dropdown.anchor === Item.TopRight
        property bool bottom : __dropdown.anchor === Item.Bottom || __dropdown.anchor === Item.BottomLeft || __dropdown.anchor === Item.BottomRight
        property bool center : __dropdown.anchor === Item.Center
    }

    CustomView {
        id: __view
        elevation: 2
        radius: 2

        anchors {
            left: __internal.left ? parent.left : undefined
            right: __internal.right ? parent.right : undefined
            top: __internal.top ? parent.top : undefined
            bottom: __internal.bottom ? parent.bottom : undefined
            horizontalCenter: __internal.center ? parent.horizontalCenter : undefined
            verticalCenter: __internal.center ? parent.verticalCenter : undefined
        }
    }

    state: showing ? 'open' : 'closed'

    states: [
        State {
            name: 'closed'

            PropertyChanges {
                target: __view
                opacity: 0
            }
        },

        State {
            name: 'open'

            PropertyChanges {
                target: __view
                opacity: 1
                width: __dropdown.width
                height: __dropdown.height
            }
        }
    ]

    transitions: [
        Transition {
            from: 'open'
            to: 'closed'

            NumberAnimation {
                target: internalView
                property: 'opacity'
                duration: 400
                easing.type: Easing.InOutQuad
            }

            SequentialAnimation {

                PauseAnimation {
                    duration: 200
                }

                NumberAnimation {
                    target: internalView
                    property: 'width'
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }

            NumberAnimation {
                target: internalView
                property: 'height'
                duration: 400
                easing.type: Easing.InOutQuad
            }
        },

        Transition {
            from: 'closed'
            to: 'open'

            NumberAnimation { target: internalView; property: 'opacity'; duration: 400; easing.type: Easing.InOutQuad; }
            NumberAnimation { target: internalView; property: 'width';   duration: 200; easing.type: Easing.InOutQuad; }
            NumberAnimation { target: internalView; property: 'height';  duration: 400; easing.type: Easing.InOutQuad; }
        }
    ]
}
