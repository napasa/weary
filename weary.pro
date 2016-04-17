TEMPLATE = app

QT += qml quick
SOURCES += main.cpp \
    fileio.cpp \
    clien.cpp \
    myquickview.cpp \
    interactsql.cpp
RESOURCES += \
    wearymaster.qrc
CONFIG+=c++11
CONFIG+=qml_debug
OTHER_FILES += *.qml content/*.qml content/images/*.png
#target.path = $$[QT_INSTALL_EXAMPLES]/quick/demos/stocqt
INSTALLS += target

HEADERS += \
    fileio.h \
    clien.h \
    myquickview.h \
    interactsql.h \
    interactsql_global.h

DISTFILES += \
    content/FrameLess.qml \
    content/SelectBtn.qml \
    content/SiblingEditable.qml \
    content/SiblingLable.qml

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../db/mysql-connector/lib/release/ -lmysqlcppconn
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../db/mysql-connector/lib/debug/ -lmysqlcppconn
else:unix: LIBS += -L$$PWD/../db/mysql-connector/lib/ -lmysqlcppconn

INCLUDEPATH += $$PWD/../db/mysql-connector/include
DEPENDPATH += $$PWD/../db/mysql-connector/include
