import QtQuick 2.12
import QtQuick.Window 2.12

/*!
 * \qmltype CustomPopupBase
 * \brief Базовый класс для всплывающих окон, таких как диалоги или выпадающие списки.
 */
FocusScope {
    id: popup

    property color overlayColor: 'transparent'
    property string overlayLayer: 'overlayLayer'
    property bool globalMouseAreaEnabled: true
    property bool dismissOnTap: true
    property bool showing: false
    property bool closeOnResize: false
    property Item lastFocusedItem

    signal opened
    signal closed

    function toggle (_widget) {
        if (showing)
            close();
        else
            open(_widget);
    }

    function open () {
        lastFocusedItem = Window.activeFocusItem;
        parent = findRootChild(popup, overlayLayer);

        if (!parent.enabled)
            return;

        showing = true;
        forceActiveFocus();
        parent.currentOverlay = popup;

        opened();
    }

    function close () {
        showing = false;

        if (parent.hasOwnProperty('currentOverlay'))
            parent.currentOverlay = null;

        closed();
    }

    function findRoot (_obj) {
        while (_obj.parent)
            _obj = _obj.parent;

        return _obj;
    }

    function findRootChild (_obj, _objectName) {
        _obj = findRoot(_obj);

        var _childs = new Array(0);
        _childs.push(_obj);

        while (_childs.length > 0)
        {
            if (_childs[0].objectName === _objectName)
                return _childs[0];

            for (var i in _childs[0].data)
                _childs.push(_childs[0].data[i]);

            _childs.splice(0, 1);
        }

        return null;
    }
}
