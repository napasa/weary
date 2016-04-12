#include "interactsql.h"
#include <math.h>


InteractSQL::InteractSQL(QObject *parent, const QString &host, const QString &database, const QString &user, const QString &password)
    :QObject(parent)
{
    try {
        driver = get_driver_instance();
        con = driver->connect(host.toStdString(), user.toStdString(), password.toStdString());
        con->setAutoCommit(0);
        con->setSchema(database.toStdString());
        stmt = con->createStatement();

        QString str_prep_stmt_0="INSERT INTO baseInfo(id, pwd, name, sex, score, changed, uploadTimes) VALUE(?,?,?,?,?,?,?)" ;
        QString str_prep_stmt_1 = QString("SELECT date, heartRate, temperature, pressure, pulse, score, changed FROM ").append(DETAITABLE)\
                .append(" WHERE id= ? ORDER BY date DESC");
        QString str_prep_stmt_2 = QString("INSERT INTO detailInfo(id, date, heartRate, temperature, pressure, pulse) VALUE(?, ?, ?, ?, ?, ?)");
        QString str_prep_stmt_3 = QString("UPDATE ").append(BASEINFOTABLE).append(" SET uploadTimes=?, changed=?, score=? WHERE id=?");

        prep_register_stmt = con->prepareStatement(str_prep_stmt_0.toStdString());
        prep_retriveIndexInfo_stmt = con->prepareStatement(str_prep_stmt_1.toStdString());
        prep_uploadInfo_stmt = con->prepareStatement(str_prep_stmt_2.toStdString());
        prep_alterUploadTimes_stmt = con->prepareStatement(str_prep_stmt_3.toStdString());
    }catch (SQLException &e) {
            cout << "ERROR: SQLException in " << __FILE__;
            cout << " (" << __func__<< ") on line " << __LINE__ << endl;
            cout << "ERROR: " << e.what();
            cout << " (MySQL error code: " << e.getErrorCode();
            cout << ", SQLState: " << e.getSQLState() << ")" << endl;

            if (e.getErrorCode() == 1047) {
                cout << "\nYour server does not seem to support Prepared Statements at all. ";
                cout << "Perhaps MYSQL < 4.1?" << endl;
            }
    }
}

bool InteractSQL::registerAccount(const QString &userID, const QString &userPwd, const QString &userName, const QString &userGender)
{
try{
    if(userID.length()>20 || userPwd.length()>20 || userName.length()>20 || userGender.length()>1)
        return false;
    sqlStmt.clear();
    sqlStmt.append( "SELECT DISTINCT id FROM ").append(BASEINFOTABLE)\
            .append(" WHERE id=\'").append(userID).append("\'");
    res = stmt->executeQuery(sqlStmt.toStdString());
    while(res->next()){
        if(res->getString(QString("id").toStdString()) == userID.toStdString()){
                return false;
        }
    }
    prep_register_stmt->setString(1, userID.toStdString());
    prep_register_stmt->setString(2, userPwd.toStdString());
    prep_register_stmt->setString(3, userName.toStdString());
    prep_register_stmt->setString(4, userGender.toStdString());
    prep_register_stmt->setInt(5, 0);
    prep_register_stmt->setInt(6, 0);
    prep_register_stmt->setInt(7,0);
    affectedColumns = prep_register_stmt->executeUpdate();
    con->commit();
    if(affectedColumns!=0){
        emit registerStatusChanged(true);
        return true;
    }
    }catch (SQLException &e) {
            cout << "ERROR: SQLException in " << __FILE__;
            cout << " (" << __func__<< ") on line " << __LINE__ << endl;
            cout << "ERROR: " << e.what();
            cout << " (MySQL error code: " << e.getErrorCode();
            cout << ", SQLState: " << e.getSQLState() << ")" << endl;

            if (e.getErrorCode() == 1047) {
                cout << "\nYour server does not seem to support Prepared Statements at all. ";
                cout << "Perhaps MYSQL < 4.1?" << endl;
            }
    }
    emit registerStatusChanged(false);
    return false;
}

bool InteractSQL::loginAccount(const QString &userID, const QString &userPwd)
{
try{
    sqlStmt.clear();
    sqlStmt.append( "SELECT DISTINCT id,pwd FROM ").append(BASEINFOTABLE).append(" WHERE id=\"")\
            .append(userID).append("\";");
    res = stmt->executeQuery(sqlStmt.toStdString());
    while(res->next()){
        if(res->getString(QString("id").toStdString()).asStdString() == userID.toStdString()){
            if(res->getString(QString("pwd").toStdString()).asStdString() == userPwd.toStdString()){
                emit loginStatusChanged(true);
                return true;
            }
        }
    }
    emit loginStatusChanged(false);
    return false;
    }catch (SQLException &e) {
            cout << "ERROR: SQLException in " << __FILE__;
            cout << " (" << __func__<< ") on line " << __LINE__ << endl;
            cout << "ERROR: " << e.what();
            cout << " (MySQL error code: " << e.getErrorCode();
            cout << ", SQLState: " << e.getSQLState() << ")" << endl;

            if (e.getErrorCode() == 1047) {
                cout << "\nYour server does not seem to support Prepared Statements at all. ";
                cout << "Perhaps MYSQL < 4.1?" << endl;
            }
    }
    emit loginStatusChanged(false);
    return false;
}

bool InteractSQL::retriveAllUsersBaseInfo()
{
try{
    int i=0;
    QVector<QString> indexPair;
    QVector<QString> infoPair;
    sqlStmt.clear();
    sqlStmt.append( "SELECT id,name,sex,score,changed FROM ").append(BASEINFOTABLE)\
            .append(" ORDER BY NAME;");
    res = stmt->executeQuery(sqlStmt.toStdString());
    infoPair.clear();
    while (res->next()) {
        indexPair.clear();
        while (i!=5) {
            if( i == 3)     indexPair.push_back(formatPair(BaseColumnId[3], res->getDouble(BaseColumnId[3])));
            else if(i == 4) indexPair.push_back(formatPair(BaseColumnId[4], res->getInt(BaseColumnId[4])));
            else    indexPair.push_back(formatPair(BaseColumnId[i], res->getString(BaseColumnId[i])));
            i++;
        }
        baseInfo.clear();
        for(QVector<QString>::iterator it =indexPair.begin(); it!=indexPair.end(); it++ ){
            if(it != indexPair.end()-1){
                baseInfo.append(*it).append(",");
            }
            else{
                baseInfo.append(*it);
            }
        }
        baseInfo.prepend("{").append("}");
        infoPair.push_back(baseInfo);
        i=0;
    }
    baseInfo.clear();
    for(QVector<QString>::iterator it =infoPair.begin(); it !=infoPair.end(); it++){
        if(it != infoPair.end()-1){
            baseInfo.append(*it).append(",");
        }
        else baseInfo.append(*it);
    }
    baseInfo.prepend("[").append("]");
    emit retriveBaseInfoStatusChanged(true);
    return true;
    }catch (SQLException &e) {
            cout << "ERROR: SQLException in " << __FILE__;
            cout << " (" << __func__<< ") on line " << __LINE__ << endl;
            cout << "ERROR: " << e.what();
            cout << " (MySQL error code: " << e.getErrorCode();
            cout << ", SQLState: " << e.getSQLState() << ")" << endl;

            if (e.getErrorCode() == 1047) {
                cout << "\nYour server does not seem to support Prepared Statements at all. ";
                cout << "Perhaps MYSQL < 4.1?" << endl;
            }
    }
    emit retriveBaseInfoStatusChanged(false);
    return false;
}

QString InteractSQL::formatPair(const std::string &key, const std::string &value)
{
    return QString::fromStdString(std::string(" \"").append(key).append("\": \"").append(value).append("\" "));
}

QString InteractSQL::formatPair(const string &key, const int &value)
{
    return QString::fromStdString(std::string(" \"").append(key).append("\": ").append(std::to_string(value)));
}

QString InteractSQL::formatPair(const string &key, const long double &value)
{
    return QString::fromStdString( std::string(" \"").append(key).append("\": ").append(std::to_string(value)));
}

bool InteractSQL::retriveUserDetailInfo(const QString &userID)
{
try{
   int i=0;
   QVector<QString> indexPair;
   QVector<QString> infoPair;

   prep_retriveIndexInfo_stmt->setString(1, userID.toStdString());
   res = prep_retriveIndexInfo_stmt->executeQuery();

   infoPair.clear();
    while (res->next()) {
        i=0;
        indexPair.clear();
        while(i!=7){
            if(i == 0) indexPair.push_back(formatPair(DetailColumnId[0], res->getString(DetailColumnId[0])));
            else    indexPair.push_back(formatPair(DetailColumnId[i], res->getDouble(DetailColumnId[i])));
            i++;
        }
        detailInfo.clear();
        for(QVector<QString>::iterator it =indexPair.begin(); it!=indexPair.end(); it++ ){
            if(it != indexPair.end()-1){
                detailInfo.append(*it).append(",");
            }
            else{
                detailInfo.append(*it);
            }
        }
        detailInfo.prepend("{").append("}");
        infoPair.push_back(detailInfo);
    }
    detailInfo.clear();
    for(QVector<QString>::iterator it =infoPair.begin(); it !=infoPair.end(); it++){
        if(it != infoPair.end()-1){
            detailInfo.append(*it).append(",");
        }
        else detailInfo.append(*it);
    }
    detailInfo.prepend("[").append("]");
    emit retriveDetailBaseStatusChanged(true);
    return true;
    }catch (SQLException &e) {
            cout << "ERROR: SQLException in " << __FILE__;
            cout << " (" << __func__<< ") on line " << __LINE__ << endl;
            cout << "ERROR: " << e.what();
            cout << " (MySQL error code: " << e.getErrorCode();
            cout << ", SQLState: " << e.getSQLState() << ")" << endl;

            if (e.getErrorCode() == 1047) {
                cout << "\nYour server does not seem to support Prepared Statements at all. ";
                cout << "Perhaps MYSQL < 4.1?" << endl;
            }
    }
    emit retriveDetailBaseStatusChanged(false);
    return false;
}

float itemScore(float reality, float standard)
{
    float  j  = reality/standard-1;
    if(j<0) j=-j;
    float i =  (1-j)*100;
    return i;
}

float averageScore(float reality, float times, float aver)
{
    float  i = (reality+times*aver)/(times+1);
    return i;
}

bool InteractSQL::uploadTodayInfo(const QString &userID, const QString &date, const int heartRate, const int temperature, const int pressure, const int pulse)
{
    float averScore, lastAverScore, times;
    try{
        /****whether id is registered***/
        sqlStmt.clear();
        sqlStmt.append( "SELECT DISTINCT id,score,uploadTimes FROM ").append(BASEINFOTABLE)\
                .append(" WHERE id=\"").append(userID).append("\"");
        res = stmt->executeQuery(sqlStmt.toStdString());
        while(res->next()){
            if(res->getString(QString("id").toStdString()) != userID.toStdString()){
                    emit uploadStatusChanged(false);
                    return false;
            }
            lastAverScore = res->getInt(QString("score").toStdString());
            times = res->getInt(QString("uploadTimes").toStdString());
        }
        /***whether data of today has uploaded***/
        sqlStmt.clear();
        sqlStmt.append("SELECT DISTINCT date FROM ").append(DETAITABLE).append(" WHERE date='").append(date).append("'");
        res = stmt->executeQuery(sqlStmt.toStdString());
        if(res->next()){
            emit uploadStatusChanged(false);
            return false;
        }
        prep_uploadInfo_stmt->clearParameters();
        prep_uploadInfo_stmt->setString(1, userID.toStdString());
        prep_uploadInfo_stmt->setString(2, date.toStdString());
        prep_uploadInfo_stmt->setInt(3, heartRate);
        prep_uploadInfo_stmt->setInt(4, temperature);
        prep_uploadInfo_stmt->setInt(5, pressure);
        prep_uploadInfo_stmt->setInt(6, pulse);
        affectedColumns = prep_uploadInfo_stmt->executeUpdate();
        con->commit();
        if(affectedColumns==0){
            emit uploadStatusChanged(false);
            return false;
        }
        /***update a target user soce and changed numeric***/
        averScore =(itemScore(heartRate, HEARTRATESTANDARD) + itemScore(temperature, temperatureSTARNDARD)\
                + itemScore(pressure, PRESSURESTARDANRD) + itemScore(pulse, PULSESTANDARD))/4;
        averScore = averageScore(averScore, times, lastAverScore);
        prep_alterUploadTimes_stmt->clearParameters();
        prep_alterUploadTimes_stmt->setInt(1, times+1);
        prep_alterUploadTimes_stmt->setDouble(2, averScore-lastAverScore);
        prep_alterUploadTimes_stmt->setDouble(3, averScore);
        prep_alterUploadTimes_stmt->setString(4, userID.toStdString());
        affectedColumns = prep_alterUploadTimes_stmt->executeUpdate();
        con->commit();
        if(affectedColumns!=0){
            emit uploadStatusChanged(false);
            return true;
        }
    }catch (SQLException &e) {
        cout << "ERROR: SQLException in " << __FILE__;
        cout << " (" << __func__<< ") on line " << __LINE__ << endl;
        cout << "ERROR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << ")" << endl;

        if (e.getErrorCode() == 1047) {
            cout << "\nYour server does not seem to support Prepared Statements at all. ";
            cout << "Perhaps MYSQL < 4.1?" << endl;
        }
    }
    emit uploadStatusChanged(false);
    return false;
}

