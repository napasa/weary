#ifndef INTERACTSQL_H
#define INTERACTSQL_H

#include "interactsql_global.h"
#include <QtCore>
using namespace sql;
using namespace std;
class  InteractSQL : public QObject
{
    Q_OBJECT
public:
    InteractSQL(QObject *parent=0, const QString &host=DBHOST, const QString &database=DATABASE, const QString &user=USER, const QString &password=PASSWORD);
    Q_INVOKABLE bool registerAccount(const QString &userID, const QString &userPwd, const QString &userName, const QString &userGender);
    Q_INVOKABLE bool loginAccount(const QString &userID, const QString &userPassword);
    Q_INVOKABLE bool retriveAllUsersBaseInfo();
    Q_INVOKABLE bool retriveUserDetailInfo(const QString &userID);
    Q_INVOKABLE bool uploadTodayInfo(const QString &userID, const QString &date, const int heartRate, const int temperature, const int pressure, const int pulse);
    Q_INVOKABLE const QString getDetailInfo()const{return detailInfo;}
    Q_INVOKABLE const QString getBaseInfo()const{return baseInfo;}
    ~InteractSQL(){}
signals:
    void registerStatusChanged(bool status);
    void loginStatusChanged(bool status);
    void retriveBaseInfoStatusChanged(bool status);
    void retriveDetailBaseStatusChanged(bool status);
    void uploadStatusChanged(bool status);
private:
    void connect(const QString &host, const QString &database, const QString, const QString &password);

    QString formatPair(const std::string &key, const std::string &value);
    QString formatPair(const string &key, const int &value);
    QString formatPair(const string &key, const long double &value);

    Driver *driver;
    Connection *con;
    Statement *stmt;
    PreparedStatement *prep_register_stmt;
    PreparedStatement *prep_retriveIndexInfo_stmt;
    PreparedStatement *prep_uploadInfo_stmt;
    PreparedStatement *prep_alterUploadTimes_stmt;
    ResultSet *res;
    QString detailInfo;
    QString baseInfo;
    int affectedColumns;
    QString sqlStmt;
};

#endif // INTERACTSQL_H

