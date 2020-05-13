#include "socket_client.hpp"
#include "client_helper.hpp"

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

#include <cstdlib>
#include <cstdio>
#include <unistd.h>

#define ADDRESS "/tmp/umcm" ///< Адрес для подключения

#include <QDebug>

static ClientHelper *__parent;

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

SocketClient::SocketClient (ClientHelper *_parent)
{
    __parent = _parent;
}

SocketClient::~SocketClient ()
{
    stop();
}

/*!
 * \brief Инициализация сокета
 */
void SocketClient::start ()
{
    int _length;
    struct sockaddr_un _address;

    /*
     * Получение сокета для работы.
     * Этот сокет будет находиться в домене UNIX и будет сокетом потока.
     */
    if ((m_socket = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    {
        perror("client: socket");
        return; // exit(1);
    }

    /*
     * Создание адреса, к которому будет происходить подключение.
     */
    _address.sun_family = AF_UNIX;
    strcpy(_address.sun_path, ADDRESS);

    /*
     * Попытка подключения по адресу.
     * Для этого сервер должен уже связать этот адрес и выдать запрос listen().
     * Третий аргумент указывает "длину" структуры, а не только длину имени сокета.
     */
    _length = sizeof(_address.sun_family) + strlen(_address.sun_path);

    if (connect(m_socket, (struct sockaddr *)&_address, _length) < 0)
    {
        perror("client: connect");
    }
}

/*!
 * \brief Закрытие сокета
 */
void SocketClient::stop ()
{
    /*
     * Можно просто использовать close(), чтобы разорвать соединение, так как завершено с обеих сторон.
     */
    if (m_socket >= 0)
        close(m_socket);
}

/*!
 * \brief Формирование и отправка запроса на сервер
 * \param _type - Тип запроса
 * \param _channel - Номер канала
 * \return
 */
bool SocketClient::sendRequest (int _type, int _channel, ...)
{
    if (m_socket < 0)
        return false;

    char _reqBuffer[256];
    char _channelBuffer[20];

    switch (_type)
    {
    case ClientHelper::StartMeasure : strcpy(_reqBuffer, "start_measure "); break;
    case ClientHelper::StopMeasure  : strcpy(_reqBuffer, "stop_measure ");  break;
    case ClientHelper::SetRange     : strcpy(_reqBuffer, "set_range ");     break;
    case ClientHelper::GetStatus    : strcpy(_reqBuffer, "get_status ");    break;
    case ClientHelper::GetResult    : strcpy(_reqBuffer, "get_result ");    break;
    }

    sprintf(_channelBuffer, "channel%d", _channel);
    strcat(_reqBuffer, _channelBuffer);

    if (_type == ClientHelper::SetRange)
    {
        char _rangeBuffer[9];
        va_list _args;

        va_start(_args, _channel);
        sprintf(_rangeBuffer, ", range%d", va_arg(_args, int));
        va_end(_args);

        strcat(_reqBuffer, _rangeBuffer);
    }

    strcat(_reqBuffer, "\n");
    send(m_socket, _reqBuffer, strlen(_reqBuffer), 0);

    qDebug() << "[req]" << _reqBuffer;
    usleep(500);

    char _rspRawBuffer[256];
    bzero(_rspRawBuffer, 256);
    int _result = recv(m_socket, _rspRawBuffer, 255, 0);

    if (_result <= 0)
        return false;

    char _rspBuffer[256];
    bzero(_rspBuffer, 256);
    strncpy(_rspBuffer, _rspRawBuffer, strlen(_rspRawBuffer) - 1);
    qDebug() << "[rsp]" << _rspBuffer;

    const std::vector<std::string> _rsp = explode(_rspBuffer, ' ');

    switch (_type)
    {
    case ClientHelper::StartMeasure:
        break;
    case ClientHelper::StopMeasure:
        break;
    case ClientHelper::SetRange:
        if (_rsp.at(0) == "ok,")
        {
            emit __parent->updateRange(_channel, std::stoi(_rsp.at(1).substr(5)));
        }
        break;
    case ClientHelper::GetStatus:
        if (_rsp.at(0) == "ok,")
        {
            if (_rsp.at(1) == "error_state")
                emit __parent->updateState(_channel, ClientHelper::ErrorState);
            else if (_rsp.at(1) == "idle_state")
                emit __parent->updateState(_channel, ClientHelper::IddleState);
            else if (_rsp.at(1) == "measure_state")
                emit __parent->updateState(_channel, ClientHelper::MeasureState);
            else if (_rsp.at(1) == "busy_state")
                emit __parent->updateState(_channel, ClientHelper::BusyState);
        }
        break;
    case ClientHelper::GetResult:
        if (_rsp.at(0) == "ok,")
            emit __parent->updateValue(_channel, std::stod(_rsp.at(1)));
        break;
    }

    return true;
}

