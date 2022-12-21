import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;
import Toybox.Activity;

using Toybox.ActivityRecording;
using Toybox.ActivityMonitor;
using Toybox.System as Sys;

// Here are all Buttons defined -> business logic
class BWFDelegate extends WatchUi.InputDelegate {

    private var _inProgress = false;

    private var _timer;
    private var _view = getView();

    var myCounter = 0;


    function initialize() {
        InputDelegate.initialize();
    }

    function onTap(clickEvent) {
      //return onSelect();  -> deactivation of touch screen
      return true;
    }

    function onHold(clickEvent) {
        return true;
    }
        
    function onSwipe(evt) {
        return true;
    }

    function onKey(keyEvent) {
        Sys.println("key event " + keyEvent.getKey());
        // ENTER/START
        if (keyEvent.getKey() == WatchUi.KEY_ENTER || keyEvent.getKey() == WatchUi.KEY_START) {
            return onSelect();
        }
        // BACK
        else if (keyEvent.getKey() == WatchUi.KEY_LAP || keyEvent.getKey() == WatchUi.KEY_ESC) {
            return onBack();
        }
        // UP
        else if (keyEvent.getKey() == WatchUi.KEY_UP) {
            return onPreviousPage();
        }
        // DOWN
        else if (keyEvent.getKey() == WatchUi.KEY_DOWN) {
            return onNextPage();
        }
        return false;
    }

    function onSelect() as Boolean {
        if (_inProgress == false) {
            _inProgress = true;
            Sys.println("DEBUG: function BWFDelegate.onSelect() -> startCountdown()");
            startCountdown();
        } else {
            _inProgress = false;
            Sys.println("DEBUG: function BWFDelegate.onSelect() -> stopCountdown()");
            _timer.stop();
        }
        return true;
    }

    function onBack() {
        Sys.println("DEBUG: function BWFDelegate.onBack()");
        return true;
    }

    function onNextPage() {
        Sys.println("DEBUG: function BWFDelegate.onNextPage()");
        return true;
    }

    function onPreviousPage() {
        Sys.println("DEBUG: function BWFDelegate.onPreviousPage()");
        return true;
    }

    function startCountdown() {
        Sys.println("DEBUG: function BWFDelegate.startCountdown()");

        _timer = new Timer.Timer();
        // every second call this method -> updateCountdownValue
        _timer.start(method(:updateParamValues), 1000, true);
    }

    function updateParamValues() as Void {
        Sys.println("DEBUG: bwf_App.updateParamValues() -> HR / MAX-HR / CALORIES");
        var actInfo = Activity.getActivityInfo();
        myCounter = myCounter +1;

        _view.setCurrentHR(actInfo.currentHeartRate);
        _view.setMaxHR(actInfo.maxHeartRate);
        _view.setCalories(actInfo.calories);
        _view.leftTimer(myCounter);

    }
}
