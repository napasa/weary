/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QDir>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlFileSelector>
#include <QtQml>
#include <QQuickView> //Not using QQmlApplicationEngine because many examples don't have a Window{}
#include <QObject>
#include "fileio.h"
#include "clien.h"
#include "myquickview.h"
#include "interactsql.h"
int main(int argc, char* argv[])
{
    QGuiApplication app(argc,argv);
    qmlRegisterType<FileIO>("IOs", 1, 0, "FileIO");
    qmlRegisterType<Clien>("IOs", 1, 0, "Clien");
    qmlRegisterType<InteractSQL>("SQL", 1,0, "MySQL");
    app.setOrganizationName("QtProject");
    app.setOrganizationDomain("qt-project.org");
    app.setApplicationName(QFileInfo(app.applicationFilePath()).baseName());
    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/demos/stocqt/LogWin.qml"));
    engine.load(QUrl("qrc:/demos/stocqt/wearyMaster.qml"));
    QObject *logOrRegObject = engine.rootObjects().value(0);
    QObject *mainObject = engine.rootObjects().value(1);
    QObject *listViewObject = mainObject->findChild<QObject*>("userListView");
    QQuickWindow *logOrRegView = qobject_cast<QQuickWindow *>(logOrRegObject);
    QQuickWindow *mainView = qobject_cast<QQuickWindow *>(mainObject);
    logOrRegView->show();
    if (qgetenv("QT_QUICK_CORE_PROFILE").toInt()) {
        QSurfaceFormat f = mainView->format();
        f.setProfile(QSurfaceFormat::CoreProfile);
        f.setVersion(4, 4);
        mainView->setFormat(f);
    }\

    QObject::connect(logOrRegObject, SIGNAL(exited()), logOrRegView, SLOT(close()));
    QObject::connect(logOrRegObject, SIGNAL(exited()), mainView, SLOT(close()));
    QObject::connect(logOrRegObject, SIGNAL(log()), mainView, SLOT(show()));
    QObject::connect(logOrRegObject, SIGNAL(log()), logOrRegView, SLOT(close()));
    QObject::connect(logOrRegObject, SIGNAL(log()), listViewObject, SLOT(retriveBaseInfo()));
    QObject::connect(logOrRegObject, SIGNAL(transferAc(QVariant)), mainView, SLOT(receiveAc(QVariant)));
    QObject::connect(mainObject, SIGNAL(exitProc()), &app, SLOT(quit()));
    return app.exec();
}
