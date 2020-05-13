#ifndef SOCKET_SERVER_HPP
#define SOCKET_SERVER_HPP

#include <string>

class SocketServer
{
public:
    SocketServer ();
    ~SocketServer ();

    void start ();
    void stop ();

private:
    void handle ();
    void doprocessing (int _socket);

    int m_socket { -1 };
};

#endif // SOCKET_SERVER_HPP
