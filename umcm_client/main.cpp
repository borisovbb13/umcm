#include <QtCore/QVariant>
#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include "client_helper.hpp"
#include "indicators_model.hpp"

// Количество каналов прибора
#define CHANNELS_COUNT 40

void addFonts ()
{
    QFontDatabase _fdb;

    if (!_fdb.families().contains("Roboto"))
    {
        QFontDatabase::addApplicationFont(":/Roboto-Black.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-BlackItalic.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-Bold.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-BoldItalic.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-Italic.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-Light.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-LightItalic.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-Medium.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-MediumItalic.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-Regular.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-Thin.ttf");
        QFontDatabase::addApplicationFont(":/Roboto-ThinItalic.ttf");
    }
}

int main (int _argc, char *_argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication _app(_argc, _argv);
    QQmlApplicationEngine _engine;
    const QUrl _url(QStringLiteral("qrc:/AppWindow.qml"));

    IndicatorsModel _indicatorsModel;
    _indicatorsModel.init(CHANNELS_COUNT);
    _engine.rootContext()->setContextProperty("indicatorsModel", &_indicatorsModel);

    ClientHelper _clientHelper;
    _clientHelper.init();
    _engine.rootContext()->setContextProperty("clientHelper", &_clientHelper);

    QStringList _ranges;
    _ranges.push_back("0.0000001 .. 0.001 V");
    _ranges.push_back("0.001 .. 1 V");
    _ranges.push_back("1 .. 1000 V");
    _ranges.push_back("1000 .. 1000000 V");
    _engine.rootContext()->setContextProperty("ranges", _ranges);

    addFonts();

    qmlRegisterUncreatableType<ClientHelper> ("UMCM", 0, 1, "ClientHelper", "");

    QObject::connect(&_engine, &QQmlApplicationEngine::objectCreated, &_app, [_url](QObject *_obj, const QUrl &_objUrl) {
            if (!_obj && _url == _objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    _engine.load(_url);

    return _app.exec();
}
