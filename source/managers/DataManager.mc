import Toybox.Application;

class DataManager {
    static function getCount() {
        return Application.Properties.getValue("count");
    }

    static function setCount(count) {
        Application.Properties.setValue("count", count);
    }

    static function getGPS() {
        return Application.Properties.getValue("gps");
    }

    static function setGPS(gps) {
        Application.Properties.setValue("gps", gps);
    }
}
