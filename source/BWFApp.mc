import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

using Toybox.Timer;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BWFApp extends Application.AppBase {

    private var _view;

    // Timers
    public var oUpdateTimer as Timer.Timer?;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on APPLICATION start up
    function onStart(state as Dictionary?) as Void {
        Sys.println("DEBUG: function BWFApp.onStart()");
        self.onUpdateTimer_init();
        self.oUpdateTimer = new Timer.Timer();
        self.oUpdateTimer.start(method(:onUpdateTimer_init), 1000, true);
    }

    // onStop() is called when your APPLICATION is exiting
    function onStop(state as Dictionary?) as Void {
        Sys.println("DEBUG: function BWFApp.onStop()");
        if(self.oUpdateTimer != null) {
            (self.oUpdateTimer as Timer.Timer).stop();
            self.oUpdateTimer = null;
        }
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
         Sys.println("DEBUG: function BWFApp.getInitialView()");
        _view = new BWFView();
        return [ _view, new BWFDelegate() ] as Array<Views or InputDelegates>;
    }

    function onUpdateTimer_init() as Void {
        Sys.println("DEBUG: function BWFApp.onUpdateTimer_init()");
    }

    // Returns main view instance
    function getView() as BWFView {
        Sys.println("DEBUG: function BWFApp.getViewInstance()");
        return _view;
    }
}

function getApp() as BWFApp {
    Sys.println("DEBUG: function BWFApp.getApp()");
    return Application.getApp() as BWFApp;
}

// Returns main view
function getView() as BWFView {
    Sys.println("DEBUG: function BWFApp.getViewMain()");
    return Application.getApp().getView();
}
