import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Timer;

using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// HMI 
class BWFView extends WatchUi.View {

    private var _currentHrElement;
    private var _maxHrElement;
    private var _caloriesElement;
    private var _currentTimeElement;
    private var _leftTimeElement;
    private var _cyclesLeftElement;
    private var _drawLineUpDown;

    //getActivityInfo
    var actInfo = Activity.getActivityInfo();

    function initialize() {
        View.initialize();
    }
    
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _currentHrElement = findDrawableById("current_hr");
        _maxHrElement = findDrawableById("max_hr");
        _caloriesElement = findDrawableById("calories");
        _currentTimeElement = findDrawableById("current_time");
        _leftTimeElement = findDrawableById("left_timer");
        _cyclesLeftElement = findDrawableById("cycles_left");
        _drawLineUpDown = findDrawableById("crosshair_up");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        //Sys.println("DEBUG: function BWFView.onUpdate()");          // wird alle halbe Sekunde aufgerufen
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        drawLines(dc);
        drawCircle(dc);
        updateTime();
    }

      // Request UI update
    function updateUi() as Void {
        Sys.println("DEBUG: function BWFView.updateUi()");
        Ui.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function setCurrentHR(value as Number) as Void {
        var hr = value;
        var formattedValue = hr != null ? hr.toString() : "---";
    
        _currentHrElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function setMaxHR(value as Number) as Void {
        var hr = value;
        var formattedValue = hr != null ? hr.toString() : "---";

        _maxHrElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function setCalories(value as Number) as Void {
        var cal = value;
        var formattedValue = cal != null ? cal.toString() : "---";

        _caloriesElement.setText(formattedValue);

        WatchUi.requestUpdate();
    } 

    function updateTime() as Void {
        Sys.println("DEBUG: function BWFView.updateTime() 00:00:00");
        var oTimeInfo = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var formattedValue = Lang.format("$1$:$2$:$3$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d"), oTimeInfo.sec.format("%02d")]);
        _currentTimeElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function updateCyclesValue(cycles as Number) as Void {
        //Cast Number to String 
        var multipleSign = cycles == 1 ? "" : "s"; 
        var formattedValue = cycles.toString() + "cycle" + multipleSign + "left";

        _cyclesLeftElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function drawLines(dc) as Void {
        // ... 
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT); 
        dc.setPenWidth(2); // line thickness
        dc.drawLine(dc.getWidth() / 2 +0, dc.getHeight() / 2 -80, dc.getWidth() / 2 +0, dc.getHeight() / 2 +80);
        //          <---x                     --y--                       x----->               --y--
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT); 
        dc.setPenWidth(2); // line thickness
        dc.drawLine(dc.getWidth() / 2 -150, dc.getHeight() / 2 +0, dc.getWidth() / 2 +150, dc.getHeight() / 2 +0);
    }

    function drawCircle(dc) as Void {
        if (actInfo.currentHeartRate != null)
        {
            var hr = actInfo.currentHeartRate;
            var genericZoneInfo = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);

            //Sys.println("OVERVIEW HR: " + hr + " -- " + genericZoneInfo);

            if ( hr <= genericZoneInfo[0] )  // < 124
            {
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);  
            //Sys.println("HR-ZONE 0: " + " < " +genericZoneInfo[0]);
            }
            else if ( hr > genericZoneInfo[0] && hr <= genericZoneInfo[1] )  // >124 && <135
            {    
            dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT); 
            //Sys.println("HR-ZONE 1: " + genericZoneInfo[0] + "-" +  genericZoneInfo[1]);
            }
            else if ( hr > genericZoneInfo[1] && hr <= genericZoneInfo[2] )  // >135 && <147
            {    
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT); 
            //Sys.println("HR-ZONE 2: " + genericZoneInfo[1] + "-" +  genericZoneInfo[2]);
            }
            else if ( hr > genericZoneInfo[2] && hr <= genericZoneInfo[3] )  // >147 && <159
            {
            dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT); 
            //Sys.println("HR-ZONE 3: " + genericZoneInfo[2] + "-" +  genericZoneInfo[3]);
            }
            else if ( hr > genericZoneInfo[3] && hr <= genericZoneInfo[4] )  // >159 && <172
            {
            dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT); 
            //Sys.println("HR-ZONE 4: " + genericZoneInfo[3] + "-" +  genericZoneInfo[4]);
            }
            else if ( hr > genericZoneInfo[4] && hr <= genericZoneInfo[5] ) // >172 && <185
            {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);  // > 185
            //Sys.println("HR-ZONE 5: " + genericZoneInfo[4] + "-" +  genericZoneInfo[5]);
            }
            else if ( hr >= genericZoneInfo[5] ) // >185
            {
            dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT); 
            //Sys.println("HR-ZONE 5: " +  " > " + genericZoneInfo[5]);
            }
            else {
                //Sys.println("DEFAULT: " + hr + " -- " + genericZoneInfo);
            }
        } 
        else {
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT); 
        }
        dc.setPenWidth(6);
        dc.drawCircle(dc.getWidth() / 2, dc.getHeight() / 2, 200);
    }

    function updateParamValue() as Void {
        Sys.println("DEBUG: function BWFDelegate.onUpdateParams()");

        if(actInfo.currentHeartRate != null) {
            setCurrentHR(actInfo.currentHeartRate);
        } else {
            setCurrentHR(0);
        }
        if(actInfo.maxHeartRate != null) {
            setMaxHR(actInfo.maxHeartRate);
        } else {
            setMaxHR(0);
        }
        if(actInfo.calories != null) {
            setCalories(actInfo.calories);
        } else {
            setCalories(0);
        }
    }

    function leftTimer(value as Number) as Void {
        Sys.println("DEBUG: function BWFDelegate.leftTimer() ### VALUE ### " + value);

        var msValue = value * 1000;
        var sign = "";
        if (msValue < 0) {
            sign = "-";
            msValue *= -1;
        }
        var hours = msValue / 1000 / 60 / 60;
        var mins = (msValue / 1000 / 60) % 60;
        var secs = (msValue / 1000) % 60;

        var HMS = hours.format("%02d")+":"+mins.format("%02d")+":"+secs.format("%02d");
        var HMStoString = HMS.toString();

        _leftTimeElement.setText(HMStoString);

        WatchUi.requestUpdate();
    } 

}
