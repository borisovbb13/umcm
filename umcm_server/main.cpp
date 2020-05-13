#include <sys/types.h>
#include <stdio.h>

#include "socket_server.hpp"
#include "logger.hpp"

int main (int _argc, char *_argv[])
{
    (void)_argc;
    (void)_argv;

    LOGGER->log(std::string("========================================"));
    LOGGER->log(std::string("=== Start server application"));
    LOGGER->log(std::string("========================================"));

    SocketServer _server;
    _server.start();

    return 0;
}
