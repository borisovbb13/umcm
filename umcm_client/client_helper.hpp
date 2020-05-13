#ifndef CLIENT_HELPER_HPP
#define CLIENT_HELPER_HPP

#include <QtCore/QObject>

#include "socket_client.hpp"

class ClientHelper : public QObject
{
    Q_OBJECT

public:
    enum ReqType
    {
        StartMeasure,
        StopMeasure,
        SetRange,
        GetStatus,
        GetResult
    };
    Q_ENUM(ReqType)

    enum State
    {
        ErrorState,
        IddleState,
        MeasureState,
        BusyState
    };
    Q_ENUM(State)

    explicit ClientHelper (QObject *_parent = nullptr);

public slots:
    void init ();
    void sendRequest (ReqType _type, int _channel, int _range = -1);

signals:
    void updateValue (int _channel, qreal _value);
    void updateRange (int _channel, int _range);
    void updateState (int _channel, State _state);

private:
    SocketClient * m_client { nullptr };
};

#endif // CLIENT_HELPER_HPP
