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

import QtQuick 2.0

ListModel {
    id: model
    property string userId: ""
    property string userName: ""
    property string indexDataCycle: "d"
    property bool ready: false
    property real userScore: 0.0
    property real userScoreChanged: 0.0

    signal dataReady

    function indexOf(date) {
        var newest = new Date(model.get(0).date);
        var oldest = new Date(model.get(model.count - 1).date);
        if (newest <= date)
            return -1;

        if (oldest >= date)
            return model.count - 1;

        var currDiff = 0;
        var bestDiff = Math.abs(date.getTime() - newest.getTime());
        var retval = 0;
        for (var i = 0; i < model.count; i++) {
            var d = new Date(model.get(i).date);
            currDiff = Math.abs(d.getTime() - date.getTime());
            if (currDiff < bestDiff) {
                bestDiff = currDiff;
                retval = i;
            }
            if (currDiff > bestDiff)
                return retval;
        }

        return -1;
    }
    function createUserIndex(r) {
        return {
                "date": r[0],
                "pressure":r[1],
                "heartRate":r[2],
                "temperature":r[3],
                "pulse":r[4],
                "score":r[5],
                "adjusted":r[6]
               };
    }

}
