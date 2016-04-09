#ifndef SWITCH_H
#define SWITCH_H

#include <QObject>
class QQuickView;
class QUrl;
class Switch : public QObject
{
    Q_OBJECT
public:
    explicit Switch(QObject *parent = 0, QQuickView *view=0, QUrl *url=0);

signals:

public slots:
    void createaView();
private:
    QQuickView* m_view;
    QUrl* m_url;
};

#endif // SWITCH_H
