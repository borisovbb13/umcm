#ifndef SOCKET_CLIENT_HPP
#define SOCKET_CLIENT_HPP

#include "enums.hpp"

class ClientHelper;

class SocketClient
{
public:
    SocketClient (ClientHelper *_parent);
    virtual ~SocketClient ();

    void start ();
    void stop ();
    bool sendRequest (int _type, int _channel, ...);

private:
    int m_socket    { -1 };
};

#endif // SOCKET_CLIENT_HPP
