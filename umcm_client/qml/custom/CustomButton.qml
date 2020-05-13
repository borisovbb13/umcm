import QtQuick 2.12
import QtQuick.Controls 2.12

/*!
 * \qmltype CustomButton
 * \brief Кнопка с текстовой меткой.
 * \details Кнопка четко сообщает, какие действия будут выполняться, когда пользователь ее коснется.
 *          Она состоит из текста, изображения или того и другого, разработанного в соответствии с цветовой темой вашего приложения.
 *          Существует три стандартных типа кнопок:
 * \list
 * \li Плавающая кнопка действия (floating action button): круговая материальная кнопка, которая поднимается и отображает реакцию чернил при нажатии.
 * \li Приподнятая кнопка (raised button): обычно прямоугольная материальная кнопка, которая поднимается и отображает реакцию чернил при нажатии.
 * \li Плоская кнопка (flat button): кнопка, созданная из чернил, которая отображает реакцию чернил при нажатии, но не поднимается.
 * \endlist
 *          Этот компонент обеспечивает приподнятые и плоские кнопки. Для кнопок с плавающим действием см. \l CustomActionButton.
 * \see \l {http://www.google.com/design/spec/components/buttons.html}{Material Design spec} для получения подробной информации о том, как использовать кнопку.
 * \sa CustomActionButton
 */
Button {
    id: control
    topPadding: 0
    bottomPadding: 0
    rightPadding: 0
    leftPadding: 0
    implicitHeight: contentItem.height
    implicitWidth: contentItem.width

    property int contentItemWidth: 0

    /*!
     * \brief Цвет фона кнопки.
     * \details По умолчанию это белый цвет для поднятой кнопки и прозрачный для плоской кнопки.
     */
    property color backgroundColor: elevation > 0 ? 'white' : 'transparent'

    /*!
     * \brief Контекст кнопки, которая используется для управления специальным стилем кнопок в диалогах или снекбарах.
     * \details Возможные значения: 'default', 'dialog', 'snackbar'.
     */
    property string context: 'default'

    /*!
     * \brief Высота кнопки. Обычно либо \c 0 или \c 1.
     */
    property int elevation: 0

    /*!
     * \brief Цвет текста кнопки.
     * \details По умолчанию это вычисляется на основе цвета фона, но его можно настроить на основной цвет темы или другой цвет.
     */
    property color textColor: Qt.rgba(0, 0, 0, 0.87)

    contentItem: CustomLabel {
        id: label
        height: Math.max(36, contentHeight + 16)
        width: contentItemWidth > 0 ? contentItemWidth : Math.max(88, contentWidth + 32)
        rightPadding: 16
        leftPadding: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: control.text
        fontStyle: 'button'
        color: control.enabled ? (control.hasOwnProperty('textColor') ? control.textColor : Qt.rgba(0, 0, 0, 0.87)) : Qt.rgba(0, 0, 0, 0.26)
    }

    background: CustomView {
        radius: 2
        height: label.height
        width: label.width
        anchors.fill: contentItem
        backgroundColor: (control.enabled || control.elevation === 0) ? control.backgroundColor : Qt.rgba(0, 0, 0, 0.12)
        tintColor: __mouseArea.currentCircle || control.focus || control.hovered ? Qt.rgba (0, 0, 0, __mouseArea.currentCircle ? 0.1 : elevation > 0 ? 0.03 : 0.05) : 'transparent'

        elevation: {
            var _elevation = control.elevation

            if (_elevation > 0 && (control.focus || __mouseArea.currentCircle))
                _elevation++;

            if(!control.enabled)
                _elevation = 0;

            return _elevation;
        }

        CustomInk {
            id: __mouseArea
            anchors.fill: parent
            focused: __mouseArea.focus
            focusWidth: parent.width - 30
            focusColor: Qt.darker(backgroundColor, 1.05)
            onClicked: control.clicked()
        }
    }
}
