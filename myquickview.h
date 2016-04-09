#ifndef MYQUICKVIEW_H
#define MYQUICKVIEW_H
#include<QQuickView>
#include<QtCore>
class MyQuickView : public QQuickView
{
    Q_OBJECT
public:
   explicit MyQuickView(QQuickView *parent=0);
   void getAcText(QString text);
   ~MyQuickView();
    QObject *rootViewObject;
public slots:
    QString setAcText(QString text);
    void setSource(const QUrl &);
    void setBindObject(MyQuickView *view);
signals:
    void transferAcText(QVariant text);
private:
    QString acText;
    MyQuickView *_view;

};

#endif // MYQUICKVIEW_H
