#include "clien.h"
#include <QDebug>

//通常在构造函数内进行初始化
Clien::Clien(QObject *parent) :
    QObject(parent)
{
    connectedFlag = false;
    isArrive = false;
    nextBlockSize=0;
    connect(&tcpSocket,SIGNAL(connected()),
                     this,SLOT(processConnected()));
    connect(&tcpSocket,SIGNAL(disconnected()),
                     this,SLOT(processDisconnected()));
    connect(&tcpSocket,SIGNAL(error(QAbstractSocket::SocketError)),
                     this,SLOT(processDisconnected()));
    connect(&tcpSocket,SIGNAL(readyRead()),         //数据到达信号触发读取槽
                     this,SLOT(readMessage()));
    //connectHost();
}

Clien::~Clien() //析构函数
{
}

void Clien::connectHost()
{

    tcpSocket.abort();      // 取消已有的连接
    tcpSocket.connectToHost("127.0.0.2",24693);
    connectedFlag  = true;
}

void Clien::processConnected()
{
    connectedFlag=true;
}



void Clien::processDisconnected()
{
    connectedFlag = false;
 //   if(!tcpSocket.waitForBytesWritten(3000))//后加的
 //   {
        qDebug() << "Error ";
        tcpSocket.waitForConnected(300);
 //    }
}


void Clien::readMessage()       //读取
{   m_text =QString::fromLocal8Bit(tcpSocket.readAll());

    /*Reads all available data from the device, and returns it as a QByteArray.*/
    if(!m_text.size())        //判断是否为空
        return;
    isArrive = true;
    emit textChanged();
}


void Clien::writeMessage()   //发送
{
    if(connectedFlag)
    {
        QByteArray datagram = m_construction.toLocal8Bit();
        if(!datagram.size())
            return;
        tcpSocket.write(datagram);
    }
    else
    {
        connectHost();
    }
}
QString Clien::text()
{
    return m_text;
}

QString Clien::construction() const
{
    return m_construction;
}
void Clien::setText(QString text)
{
    if(m_text == text)
        return;
    m_text = text;
}

void Clien::setConstruction(QString construction)
{
    if(m_construction == construction)
        return;
    m_construction = construction;
}

void Clien::unconnectHost()
{
    tcpSocket.abort();
}
