# Краткое резюме
Реализация тестового задания.

# Описание
В данном репозитории содержится два проекта:
*  umcm_server - серверное приложение;
*  umcm_client - клиентское приложение.

# Особенности реализации
В ходе работы возникло несколько неясных моментов в исходном тестовом задании.

 1. Использование сокета домена Unix подразумевает использование обоих приложений исключительно на одной машине.
 1. Был выбран текстовый протокол (вариант 2), т.к. первый вариант (JSON-RPC 2.0) не описан.
 1. Некорректное описание некоторых команд управления:
    * `get_status` - нет необходимости возвращать `ok`/`fail`, достаточно кода состояния;
    * `get_result` - если необходим результат по всем каналам, то не нужно в запросе указывать `channel`; в противном случае нужно возвращать только одно значение результата.
 1. Не описан механизм генерации значений на стороне сервера.
 1. Не описано ожидаемое поведение клиентского приложение. Т.е. неясно как должно происходить обновление значений.
 1. Отсутствует варфрейм или какое-либо другое описание желаемого GUI.

Учитывая вышеизложенное, реализация приложений может значительно отличаться от ожидаемой.

# Зависимости
У серверного приложения зависимости отсутствуют.

Клиентское приложение требует наличия Qt 5.12 или новее.

# Сборка
Сборка сервера аналогична сборке любого проекта, использующего CMake.
```
$ cd umcm
$ mkdir build_umcm_server
$ cd build_umcm_server
$ cmake ../umcm_server
$ make -j3
```
Сборка клиента аналогична сборке любого проекта, использующего qmake.
```
$ cd umcm
$ mkdir build_umcm_client
$ cd build_umcm_client
$ qmake ../umcm_client/umcm_client.pro
$ make -j3
```
Для облегчения процесса сборки можно воспользоваться IDE, например QtCreator.
