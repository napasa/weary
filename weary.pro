TEMPLATE = app

QT += qml quick
SOURCES += main.cpp \
    fileio.cpp \
    clien.cpp \
    myquickview.cpp
RESOURCES += \
    wearymaster.qrc
OTHER_FILES += *.qml content/*.qml content/images/*.png

#target.path = $$[QT_INSTALL_EXAMPLES]/quick/demos/stocqt
INSTALLS += target

HEADERS += \
    fileio.h \
    clien.h \
    myquickview.h

DISTFILES += \
    content/A.qml \
    content/B.qml
