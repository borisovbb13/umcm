#include "socket_server.hpp"
#include "logger.hpp"

#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <vector>

#define ADDRESS "/tmp/umcm" ///< Адрес для подключения

static std::vector<std::string> explode (const std::string &_string, const char &_divider)
{
    std::string _buffer {""};
    std::vector<std::string> _vector;

    for (auto _char : _string)
    {
        if (_char != _divider)
        {
            _buffer += _char;
        }
        else if(_char == _divider && _buffer != "")
        {
            _vector.push_back(_buffer);
            _buffer = "";
        }
    }

    if (_buffer != "")
        _vector.push_back(_buffer);

    return _vector;
}

SocketServer::SocketServer ()
{
}

SocketServer::~SocketServer ()
{
}

void SocketServer::start ()
{
    struct sockaddr_un _serverAddress;

    /*
     * Получение сокета для работы.
     * Этот сокет будет находиться в домене UNIX и будет сокетом потока
     */
    m_socket = socket(AF_UNIX, SOCK_STREAM, 0);

    if (m_socket < 0)
    {
        LOGGER->log(std::string("ERROR oppening socket"));
        perror("umcm_server: ERROR oppening socket");
        return;
    }

    /*
     * Создание адреса, к которому будем привязываться
     */
    _serverAddress.sun_family = AF_UNIX;
    strcpy(_serverAddress.sun_path, ADDRESS);

    /*
     * Попытка привязать адрес к сокету
     * Сначала отвязываем адрес, чтобы связывание не завершилось ошибкой
     * Третий аргумент указывает "длину" структуры, а не только длину имени сокета
     */
    unlink(ADDRESS);
    int _length = sizeof(_serverAddress.sun_family) + strlen(_serverAddress.sun_path);

    if (bind(m_socket, (struct sockaddr *)&_serverAddress, _length) < 0)
    {
        LOGGER->log(std::string("ERROR on binding"));
        perror("umcm_server: ERROR on binding");
        return;
    }

    handle();
}

void SocketServer::stop ()
{
    /*
     * Можно просто использовать close(), чтобы разорвать соединение, так как завершено с обеих сторон.
     */
    close(m_socket);

    LOGGER->log("Socket server was stopped");
}

void SocketServer::handle ()
{
    int _newSocket;
    int _pid;
    int _addressLength;
    struct sockaddr_un _clientAddress;

    /*
     * Слушаем сокет
     */
    if (listen(m_socket, 5) != 0)
    {
        LOGGER->log(std::string("ERROR on listening"));
        perror("umcm_server: ERROR on listening");
        return;
    }

    while (true)
    {
        /*
         * Принятие соединений.
         * Когда примем одно, _newSocket будет подключен к клиенту.
         * _clientAddress будет содержать адрес клиента.
         */
        _newSocket = accept(m_socket, (struct sockaddr *)&_clientAddress, (socklen_t *)&_addressLength);

        if (_newSocket < 0)
        {
            LOGGER->log(std::string("ERROR on accepting"));
            perror("umcm_server: ERROR on accepting");
            break;
        }

        // Создание дочернего процесса
        _pid = fork();

        if (_pid < 0)
        {
            LOGGER->log(std::string("ERROR on fork"));
            perror("umcm_server: ERROR on fork");
        }

        if (_pid == 0)
        {
            // Это клиентский процесс
            close(m_socket);
            doprocessing(_newSocket);
            exit(0);
        }
        else
        {
            close(_newSocket);
        }

//        usleep(200);
    }
}

void SocketServer::doprocessing (int _socket)
{
    ssize_t _result;

    char _buffer[256];
    bzero(_buffer, 256);

    _result = read(_socket, _buffer, 255);

    if (_result < 0)
    {
        LOGGER->log(std::string("ERROR reading from socket"));
        perror("umcm_server: ERROR reading from socket");
        return;
    }

    // Вывод в лог входящего сообщения (без завершающего '\n')
    char _bufStr[256];
    bzero(_bufStr, 256);
    strncpy(_bufStr, _buffer, strlen(_buffer) - 1);
    LOGGER->log("[req] %s", _bufStr);

    // Парсинг запроса
    const std::vector _req = explode(_bufStr, ' ');
    const int _reqSize = _req.size();

    // Инициализация генератора случайных чисел
    srand(time(nullptr));

    // Анализ запроса и формирование ответа
    char _rspBuffer[256];
    bzero(_rspBuffer, 256);

    const bool _isOk = (std::rand() % 3) > 0;

    if (_isOk)
        strcpy(_rspBuffer, "ok");
    else
        strcpy(_rspBuffer, "fail");

    if (_reqSize == 3 && _req.at(0) == "set_range")
    {
        // Добавляем к ответу range
        strcat(_rspBuffer, ", ");
        strcat(_rspBuffer, _req.at(2).c_str());
    }
    else if (_reqSize == 2)
    {
        if (_req.at(0) == "start_measure")
        {
            // Отправляем только 'ok' или 'fail'
        }
        else if (_req.at(0) == "stop_measure")
        {
            // Отправляем только 'ok' или 'fail'
        }
        else if (_req.at(0) == "get_status")
        {
            // Добавляем к ответу строку состояния
            const int _state = std::rand() % 7;

            if (_state == 0 || !_isOk)
                strcat(_rspBuffer, ", error_state");
            else if (_state == 1)
                strcat(_rspBuffer, ", idle_state");
            else if (_state == 2)
                strcat(_rspBuffer, ", busy_state");
            else
                strcat(_rspBuffer, ", measure_state");
        }
        else if (_req.at(0) == "get_result")
        {
            // Добавляем к ответу строку значения
            if (!_isOk)
            {
                strcat(_rspBuffer, ", 0");
            }
            else
            {
                char _valueBuffer[124];
                const float _value = (std::rand() % 1000000000) * 0.0001f;
                sprintf(_valueBuffer, ", %f", _value);
                strcat(_rspBuffer, _valueBuffer);
            }
        }
        else
        {
            LOGGER->log(std::string("ERROR: Unknown request type"));
            return;
        }
    }
    else
    {
        LOGGER->log(std::string("ERROR: Invalid number of elements in request"));
        return;
    }

    LOGGER->log("[rsp] %s", _rspBuffer);
    strcat(_rspBuffer, "\n");
    _result = write(_socket, _rspBuffer, strlen(_rspBuffer));

    if (_result < 0)
    {
        LOGGER->log(std::string("ERROR writing to socket"));
        perror("ERROR writing to socket");
    }

    close(_socket);
}
