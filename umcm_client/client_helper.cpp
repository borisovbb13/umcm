#include "client_helper.hpp"

ClientHelper::ClientHelper (QObject *_parent)
    : QObject(_parent)
{
}

void ClientHelper::init ()
{
    m_client = new SocketClient(this);
}

void ClientHelper::sendRequest (ReqType _type, int _channel, int _range)
{
    m_client->start();

    if (_type == ReqType::SetRange)
        m_client->sendRequest(_type, _channel, _range);
    else
        m_client->sendRequest(_type, _channel);

    m_client->stop();
}
