import QtQuick 2.12

/*!
 * \qmltype CustomSidebar
 * \brief Компонент боковой панели для использования в адаптивных макетах.
 * \details Чтобы использовать, просто добавьте экземпляр в свой код и привяжите к нему другие компоненты.
 *          Чтобы показать или скрыть, установите свойство \c expanded.
 *          По умолчанию боковая панель имеет встроенную выплывающую панель, и любое добавление содержимого будет помещено в текущее.
 *          Если вы хотите, чтобы это было отключено или хотите заполнить всю боковую панель, установите для свойства \c autoFlick значение \c false.
 */
CustomView {
    backgroundColor: 'white'

    anchors {
        left: mode === 'left' ? parent.left : undefined
        right: mode === 'right' ? parent.right : undefined
        top: parent.top
        bottom: parent.bottom
        leftMargin: expanded ? 0 : -width
        rightMargin: expanded ? 0 : -width
    }

    width: 250

    property bool expanded: true
    property string mode: 'left' // или 'right'
    property color borderColor: '#E5E5E5'
    property alias borderWidth: __border.width
    property bool marginDisable: false
    property bool autoFlick: true

    default property alias contents: __contents.data

    Behavior on anchors.leftMargin  { NumberAnimation { duration: 200 } }
    Behavior on anchors.rightMargin { NumberAnimation { duration: 200 } }

    Rectangle {
        id: __border
        color: borderColor
        width: 1

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: mode === 'left' ? parent.right : undefined
            left: mode === 'right' ? parent.left : undefined
        }
    }

    Item {
        clip: true

        anchors {
            fill: parent
            rightMargin: marginDisable ? 0 : (mode === 'left' ? 1 : 0)
            leftMargin: marginDisable ? 0 : (mode === 'right' ? 1 : 0)
        }

        Flickable {
            id: __flickable
            clip: true
            anchors.fill: parent
            contentWidth: width
            contentHeight: autoFlick ? __contents.height : height
            interactive: contentHeight > height

            Item {
                id: __contents
                width: __flickable.width
                height: autoFlick ? childrenRect.height : __flickable.height
            }
        }
    }
}
