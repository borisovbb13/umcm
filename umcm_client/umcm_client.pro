QT += quick

CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

HEADERS += \
    client_helper.hpp \
    indicators_model.hpp \
    socket_client.hpp

SOURCES += \
        client_helper.cpp \
        indicators_model.cpp \
        main.cpp \
        socket_client.cpp

RESOURCES += \
    qml/custom/components.qrc \
    qml/icons/icons.qrc \
    qml/fonts/fonts.qrc \
    qml/qml.qrc

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
