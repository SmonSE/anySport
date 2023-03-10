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
class anySportView extends WatchUi.View {

    private var _currentHrElement;
    private var _maxHrElement;
    private var _caloriesElement;
    private var _currentTimeElement;
    private var _leftTimeElement;
    private var _cyclesLeftElement;
    private var _drawLineUpDown;
    private var _trainEffectElement;

    //getActivityInfo
    var actInfo = Activity.getActivityInfo();
    var label, color;

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
        _trainEffectElement = findDrawableById("effect");

    }

    // Called when this View is brought to the foreground. 
    // Restore the state of this View and prepare it to be shown. 
    // This includes loading resources into memory.
    function onShow() as Void {
        Sys.println("DEBUG: function anySportView.onShow()");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        //Sys.println("DEBUG: function anySportView.onUpdate()");
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        drawLines(dc);
        drawCircle(dc);
        updateTime();
    }

      // Request UI update
    function updateUi() as Void {
        //Sys.println("DEBUG: function anySportView.updateUi()");
        Ui.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        Sys.println("DEBUG: function anySportView.onHide()");
    }

    function setCurrentHR(value as Number) as Void {
        //Sys.println("DEBUG: function anySportView.setCurrentHR()");
        var hr = value;
        var formattedValue = hr != null ? hr.toString() : "---";
    
        _currentHrElement.setText(formattedValue);

        Ui.requestUpdate();
    }

    function setMaxHR(value as Number) as Void {
        //Sys.println("DEBUG: function anySportView.setMaxHR()");
        var hr = value;
        var formattedValue = hr != null ? hr.toString() : "---";

        _maxHrElement.setText(formattedValue);

        Ui.requestUpdate();
    }

    function setCalories(value as Number) as Void {
        //Sys.println("DEBUG: function anySportView.setCalories()");
        var cal = value;
        var formattedValue = cal != null ? cal.toString() : "---";

        _caloriesElement.setText(formattedValue);

        Ui.requestUpdate();
    } 

    function setEffect(value as String) as Void {
        //Sys.println("DEBUG: function anySportView.setEffect()");

        _trainEffectElement.setText(value);

        Ui.requestUpdate();
    } 

    function updateTime() as Void {
        //Sys.println("DEBUG: function anySportView.updateTime()");
        var oTimeInfo = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var formattedValue = Lang.format("$1$:$2$:$3$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d"), oTimeInfo.sec.format("%02d")]);
        _currentTimeElement.setText(formattedValue);

        Ui.requestUpdate();
    }

    function drawLines(dc) as Void {
        //Sys.println("DEBUG: function anySportView.drawLines()");

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT); 
        dc.setPenWidth(2);
        dc.drawLine(dc.getWidth() / 2 +0, dc.getHeight() / 2 -80, dc.getWidth() / 2 +0, dc.getHeight() / 2 +80);
        //          <---x                     --y--                       x----->               --y--
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT); 
        dc.setPenWidth(2);
        dc.drawLine(dc.getWidth() / 2 -150, dc.getHeight() / 2 +0, dc.getWidth() / 2 +150, dc.getHeight() / 2 +0);
    }

    function drawCircle(dc) as Void {
        //Sys.println("DEBUG: function anySportView.drawCircle()");
        var check = Gfx.COLOR_WHITE;
        // Can be developed more pretty :)
        // At the moment it is working
        if (color != null) {
            check = color;
        } else {
            check = Gfx.COLOR_WHITE;
        }

        dc.setColor(check, Gfx.COLOR_TRANSPARENT); 
        dc.setPenWidth(6);
        dc.drawCircle(dc.getWidth() / 2, dc.getHeight() / 2, 200);
    }

    function updateParamValue() as Void {
        //Sys.println("DEBUG: function anySportDelegate.onUpdateParams()");

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
        //Sys.println("DEBUG: function anySportDelegate.leftTimer()");

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

        Ui.requestUpdate();
    } 

    function setCircleColor(circleColor as CircleColor) as Void {
        //Sys.println("DEBUG: function anySportDelegate.setCircleColor()");

        switch(circleColor) {
            case CircleColor.White:
                label = "Zone 0";
                color = Gfx.COLOR_WHITE;
                break;
            case CircleColor.Grey:
                label = "Zone 1";
                color = Gfx.COLOR_DK_GRAY;
                break;
            case CircleColor.Blue:
                label = "Zone 2";
                color = Gfx.COLOR_BLUE;
                break;
            case CircleColor.Green:
                label = "Zone 3";
                color = Gfx.COLOR_GREEN;
                break;
            case CircleColor.Orange:
                label = "Zone 4";
                color = Gfx.COLOR_YELLOW;
                break;
            case CircleColor.Red:
                label = "Zone 5";
                color = Gfx.COLOR_RED;
                break;
            case CircleColor.DarkRed:
                label = "Zone 6";
                color = Gfx.COLOR_DK_RED;
                break;
            default:
                label = "Zone";
                color = Gfx.COLOR_WHITE;
                break;
        }

        Ui.requestUpdate();
    }

}
