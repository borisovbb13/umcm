import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

/*!
 * \qmltype CustomLabel
 * \brief Компонент текстовой метки
 * \see https://material.io/design/typography/the-type-system.html#type-scale
 */
Label {
    Layout.fillWidth: true

    property string fontStyle: 'body1'

    property var fontStyles: {
        'h1'        : { 'size': 96, 'weight':   'light', 'case': 'sentence', 'spacing': -1.50 },
        'h2'        : { 'size': 60, 'weight':   'light', 'case': 'sentence', 'spacing': -0.50 },
        'h3'        : { 'size': 48, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.00 },
        'h4'        : { 'size': 34, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.25 },
        'h5'        : { 'size': 24, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.00 },
        'h6'        : { 'size': 20, 'weight':  'medium', 'case': 'sentence', 'spacing':  0.15 },
        'subtitle1' : { 'size': 16, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.15 },
        'subtitle2' : { 'size': 14, 'weight':  'medium', 'case': 'sentence', 'spacing':  0.10 },
        'body1'     : { 'size': 16, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.50 },
        'body2'     : { 'size': 14, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.25 },
        'button'    : { 'size': 14, 'weight':  'medium', 'case': 'all_caps', 'spacing':  1.25 },
        'caption'   : { 'size': 12, 'weight': 'regular', 'case': 'sentence', 'spacing':  0.40 },
        'overline'  : { 'size': 10, 'weight': 'regular', 'case': 'all_caps', 'spacing':  1.50 }
    }

    property var fontInfo: fontStyles[fontStyle]

    font {
        family: 'Roboto'
        pixelSize: fontInfo.size
        letterSpacing: fontInfo.spacing

        capitalization: {
            var _caps = fontInfo.case;

            if (_caps === 'all_caps')
                return Font.AllUppercase;
            else
                return 0;
        }

        weight: {
            var _weight = fontInfo.weight;

            switch (_weight) {
            case 'medium'  : return Font.DemiBold;
            case 'regular' : return Font.Normal;
            case 'light'   : return Font.Light;
            case 'bold'    : return Font.Bold;
            default        : return undefined;
            }
        }
    }

    color: Qt.rgba(0, 0, 0, 0.87)
}
