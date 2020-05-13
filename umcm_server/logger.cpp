#include "logger.hpp"
#include "utilities.hpp"

const std::string Logger::m_fileName = "umcm_server.log";
Logger * Logger::m_this = nullptr;
std::ofstream Logger::m_logFile;

/*!
 * \brief Возврат количества символов в строке, на которую ссылается список аргументов
 * \param _format - Формат строки
 * \param _args - Список аргументов
 * \return
 */
int argsLength (const char *_format, va_list _args)
{
    int _result;
    va_list _argsCopy;

    va_copy(_argsCopy, _args);
    _result = vsnprintf(nullptr, 0, _format, _argsCopy) + 1;  // +1, т.к. нужно учесть завершающий '\0'
    va_end(_argsCopy);

    return _result;
}

/*!
 * \brief Логирование сообщения
 * \param _message - Сообщение для логирования
 */
void Logger::log (const std::string &_message)
{
    m_logFile << util::currentDateTime() << ":\t";
    m_logFile << _message << "\n";
    m_logFile.flush();
}

/*!
 * \brief Логирование сообщения с переменным количеством параметров
 * \param _format - Формат строки логируемого сообщения
 */
void Logger::log (const char *_format, ...)
{
    char *_message = nullptr;
    int _length = 0;
    va_list _args;

    va_start(_args, _format);

    // Вернуть количество символов в строке, на которую ссылается список аргументов.
    // _vscprintf не учитывает завершающий '\0' (поэтому +1)
    _length = argsLength(_format, _args);

    _message = new char[_length];
    vsnprintf(_message, _length, _format, _args);

    log(std::string(_message));
    va_end(_args);

    delete [] _message;
}

/*!
 * \brief Потоковый ввод логируемого сообщения
 * \param _message - Сообщение для логирования
 * \return
 */
Logger &Logger::operator << (const std::string &_message)
{
    m_logFile << "\n";
    log(std::string(_message));
    return *this;
}

/*!
 * \brief Создание экземпляра класса Logger
 * \return Единичный объект класса Logger
 */
Logger * Logger::getLogger ()
{
    if (m_this == nullptr)
    {
        m_this = new Logger();
        m_logFile.open(m_fileName.c_str(), std::ios::out | std::ios::app);
    }

    return m_this;
}

/*!
 * \brief Оператор присваивания
 * \return
 */
Logger & Logger::operator = (const Logger &)
{
    return *this;
}
