import Toybox.Application;

class DataManager {
    static function getCount() {
        return Application.Properties.getValue("count");
    }

    static function setCount(count) {
        Application.Properties.setValue("count", count);
    }
}
