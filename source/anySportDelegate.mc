import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;
import Toybox.Activity;
import Toybox.Position;

using Toybox.ActivityRecording;
using Toybox.ActivityMonitor;
using Toybox.System as Sys;

// Here are all Buttons defined -> business logic
class anySportDelegate extends WatchUi.InputDelegate {

    private var _inProgress = false;
    private var _timer;
    private var _view = getView();

    var myCounter = 0;
    var session = null;

    function initialize() {
        //Sys.println("DEBUG: function anySportDelegate.initialize()");
        InputDelegate.initialize();
    }

    function onTap(clickEvent) {
        Sys.println("DEBUG: function anySportDelegate.onTap()");
        //return onSelect();  -> deactivation of touch screen
        return true;
    }

    function onHold(clickEvent) {
        //Sys.println("DEBUG: function anySportDelegate.onHold()");
        return true;
    }
  
    function onSwipe(evt) {
        //Sys.println("DEBUG: function anySportDelegate.onSwipe()");
        anySportMenuDelegate.onMenu();
        return true;
    }

    function onKey(keyEvent) {
        Sys.println("key event " + keyEvent.getKey());
        // ENTER/START
        if (keyEvent.getKey() == WatchUi.KEY_ENTER || keyEvent.getKey() == WatchUi.KEY_START) {
            return onSelect(0); 
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

    // use the select Start/Stop or touch for recording
    function onSelect(item) {
        if (item == 0) {
            if (Toybox has :ActivityRecording) {                             // check device for activity recording
                if ((session == null) || (session.isRecording() == false)) {
                    session = ActivityRecording.createSession({              // set up recording session
                            :name=>"AnySport",                               // set session name
                            :sport=>ActivityRecording.SPORT_GENERIC,         // set sport type
                            :subSport=>ActivityRecording.SUB_SPORT_GENERIC   // set sub sport type
                    });
                    session.start();                                         // call start session
                    //Sys.println("DEBUG: function anySportDelegate.onSelect() -> startCountdown()");
                    startCountdown();
                }
                else if ((session != null) && session.isRecording()) {
                    session.stop();                                         // stop the session
                    session.save();                                         // save the session
                    session = null;                                         // set session control variable to null
                    //Sys.println("DEBUG: function anySportDelegate.onSelect() -> stopCountdown()");
                    _timer.stop();
                }
            }
        } else {
            //Sys.println("DEBUG: function anySportDelegate.onDone() -> " + item.getId());
            var itemConv = item.getId().toString();
            switch (itemConv) {
                case "itemOneId":
                    //Sys.println("DEBUG: function anySportDelegate.itemOneId()");
                    anySportMenuADelegate.onMenu();
                    break;
                case "itemTwoId":
                    //Sys.println("DEBUG: function anySportDelegate.itemTwoId()");
                    break;
                case "itemThreeId":
                    //Sys.println("DEBUG: function anySportDelegate.itemThreeId()");
                    WatchUi.popView(WatchUi.SLIDE_DOWN);
                    break; 
                case "itemGpsId":
                    //Sys.println("DEBUG: function anySportDelegate.itemGpsId() STATE: " + DataManager.getGPS() );
                    if (DataManager.getGPS() == true) {
                        DataManager.setGPS(false);
                        //Sys.println("DEBUG: function anySportDelegate.itemGpsId() ON -> OFF");
                    } else {
                        //Sys.println("DEBUG: function anySportDelegate.itemGpsId() OFF -> ON");
                        DataManager.setGPS(true);
                    }
                    break;
            }
        }
        return true;                                                    // return true for onSelect function                                             
    }

    function onBack() {
        //Sys.println("DEBUG: function anySportDelegate.onBack()");
        if (session != null) {
            session.addLap();

            return true;
        } 
        DataManager.setCount(0);
        session = null;
        return false;
    }

    function onDone() {
        //Sys.println("DEBUG: function anySportDelegate.onDone()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onNextPage() {
        //Sys.println("DEBUG: function anySportDelegate.onNextPage()");
        return true;
    }

    function onPreviousPage() {
        //Sys.println("DEBUG: function anySportDelegate.onPreviousPage()");
        return true;
    }

    function startCountdown() {
        //Sys.println("DEBUG: function anySportDelegate.startCountdown()");
        _timer = new Timer.Timer();
        // every second call this method -> updateCountdownValue
        _timer.start(method(:updateParamValues), 1000, true);
    }

    function updateParamValues() as Void {
        //Sys.println("DEBUG: function anySportDelegate.updateParamValues()");
        var actInfo = Activity.getActivityInfo();
        var genericZoneInfo = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
        DataManager.setCount(DataManager.getCount() +1);

        _view.setCurrentHR(actInfo.currentHeartRate);
        _view.setMaxHR(actInfo.maxHeartRate);
        _view.setCalories(actInfo.calories);
        
        // Can be developed more pretty :)
        // At the moment it is working
        if (actInfo.trainingEffect != null) {
            var effect = actInfo.trainingEffect;
            var shortFloat = effect.format("%.2f");
            var formattedValue = shortFloat.toString();
            _view.setEffect(formattedValue);
        } else {
            _view.setEffect("---");
        }

        _view.leftTimer(DataManager.getCount());

        if (actInfo.currentHeartRate != null) {
            var hr = actInfo.currentHeartRate;

            if ( hr <= genericZoneInfo[0] )  // < 124
            {
                _view.setCircleColor(CircleColor.White);
            }
            else if ( hr > genericZoneInfo[0] && hr <= genericZoneInfo[1] )  // >124 && <135
            {    
                _view.setCircleColor(CircleColor.Grey);
            }
            else if ( hr > genericZoneInfo[1] && hr <= genericZoneInfo[2] )  // >135 && <147
            {    
                _view.setCircleColor(CircleColor.Blue);
            }
            else if ( hr > genericZoneInfo[2] && hr <= genericZoneInfo[3] )  // >147 && <159
            {
                _view.setCircleColor(CircleColor.Green);
            }
            else if ( hr > genericZoneInfo[3] && hr <= genericZoneInfo[4] )  // >159 && <172
            {
                _view.setCircleColor(CircleColor.Orange);
            }
            else if ( hr > genericZoneInfo[4] && hr <= genericZoneInfo[5] ) // >172 && <185
            {
                _view.setCircleColor(CircleColor.Red);
            }
            else if ( hr >= genericZoneInfo[5] ) // >185
            {
                _view.setCircleColor(CircleColor.DarkRed);
            }
            else {
                //Sys.println("DEFAULT: " + hr + " -- " + genericZoneInfo);
            }
        } 
        else {
            _view.setCircleColor(CircleColor.White);
        }
    }
}
