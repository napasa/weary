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
        console.log(model.get(0).date)
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
}
