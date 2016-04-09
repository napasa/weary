#include "myquickview.h"

MyQuickView::MyQuickView(QQuickView *parent)
    : QQuickView(parent)
{

}

void MyQuickView::getAcText(QString text)
{
    acText = text;

}

MyQuickView::~MyQuickView()
{

}

QString MyQuickView::setAcText(QString text)
{
    acText = text;
}

void MyQuickView::setSource(const QUrl & url)
{
    QQuickView::setSource(url);
    rootViewObject = (QObject *)QQuickView::rootObject();
    QObject::connect(this, SIGNAL(transferAcText(QVariant)), rootViewObject, SLOT(getmsg(QVariant)));
    emit transferAcText(acText);
}

void MyQuickView::setBindObject(MyQuickView *view)
{
  _view=view;
}
