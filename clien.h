#ifndef CLIEN_H
#define CLIEN_H

#include <QtNetwork/QTcpSocket>
#include <QtNetwork/QtNetwork>
#include <QtCore>


class Clien : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Clien)
    Q_PROPERTY(QString construction READ construction WRITE setConstruction)
  //  Q_PROPERTY(QString text READ text WRITE setText )
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
public:
    explicit Clien(QObject *parent = 0);
 //   Q_INVOKABLE void read();                  //Send a request.
    Q_INVOKABLE void writeMessage();
    Q_INVOKABLE void unconnectHost();
    Q_INVOKABLE void connectHost();
    QString construction() const;
    QString text() ;
    ~Clien();
public slots:
    void setText(QString text);
    void setConstruction(QString construction);
signals:
    void textChanged();
private slots:
    void processConnected();            //对成功连接状态进行处理
    void processDisconnected();         //对失败连接状态进行处理
    void readMessage();                 //读取Socket套接字内的能容




private:
    QTcpSocket tcpSocket;           //定义套接字对象
    bool connectedFlag;             //记录当前连接状态
    //定义私有成员函数，用于内部调用，进行连接
    //void connectHost();
    quint16 nextBlockSize;
    QHostAddress hostaddress;
    QString m_construction;
    QString m_text;
    bool    isArrive;
};

#endif // CLIEN_H

