#ifndef LOGGER_HPP
#define LOGGER_HPP

#include <fstream>
#include <iostream>
#include <cstdarg>
#include <string>

#define LOGGER Logger::getLogger()

/*!
 * \brief Логгер
 */
class Logger
{
public:
    void log (const std::string &_message);
    void log (const char *_format, ...);

    Logger & operator << (const std::string &_message);

    static Logger * getLogger ();

private:
    Logger () = default;

    Logger & operator = (const Logger &);

    static const std::string m_fileName;    ///< Имя файла лога
    static Logger * m_this;                 ///< Единичный указатель на объект логгера
    static std::ofstream m_logFile;         ///< Объект потока файла лога
};

#endif // LOGGER_HPP
