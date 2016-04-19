#ifndef INTERACTSQL_GLOBAL_H
#define INTERACTSQL_GLOBAL_H
#include <cppconn/driver.h>
#include <cppconn/connection.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>
#include <cppconn/resultset.h>
#include <cppconn/metadata.h>
#include <cppconn/resultset_metadata.h>
#include <cppconn/exception.h>
#include <cppconn/warning.h>
#include <QtCore/qglobal.h>
#define DBHOST "tcp://127.0.0.1:3306"
#define USER "root"
#define PASSWORD "85532648"
#define DATABASE "weary"
#define BASEINFOTABLE "baseInfo"
#define DETAITABLE "detailInfo"
#define HEARTRATESTANDARD 100
#define temperatureSTARNDARD 100
#define PRESSURESTARDANRD 100
#define PULSESTANDARD 100
#define AVERSCORE(reality, times, aver) (reality+times*aver)/(aver+1)
#define ITEMSCORE(reality, standard) (1-abs(reality/standard-1))*100
#define BasePath "/home/yhs/WearyMaster/"
const std::string BaseColumnId[8] ={"id", "name", "sex", "uploadTimes", "birthDate", "region","changed", "score"};
const std::string DetailColumnId[7] = { "date", "heartRate", "temperature", "pressure", "pulse", "score", "changed"};

#endif // INTERACTSQL_GLOBAL_H

