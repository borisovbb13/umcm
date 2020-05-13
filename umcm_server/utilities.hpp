#ifndef UTILITIES_HPP
#define UTILITIES_HPP

#include <iostream>
#include <string>
#include <time.h>

namespace util
{
// Get current date/time, format is YYYY-MM-DD.HH:mm:ss

static const std::string currentDateTime ()
{
    time_t _now = time(nullptr);
    struct tm *_timeStruct;
    char _buffer[80];

    _timeStruct = localtime(&_now);
    strftime(_buffer, sizeof(_buffer), "%Y.%m.%d %X", *&_timeStruct);
    return _buffer;
}

} // end namespace util

#endif // UTILITIES_HPP
