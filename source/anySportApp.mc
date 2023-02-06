import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

using Toybox.Timer;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


class anySportApp extends Application.AppBase {

    private var _view;

    // Timers
    public var oUpdateTimer as Timer.Timer?;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on APPLICATION start up
    function onStart(state as Dictionary?) as Void {
        //Sys.println("DEBUG: function anySportApp.onStart()");
        self.onUpdateTimer_init();
        self.oUpdateTimer = new Timer.Timer();
        self.oUpdateTimer.start(method(:onUpdateTimer_init), 1000, true);
    }

    // onStop() is called when your APPLICATION is exiting
    function onStop(state as Dictionary?) as Void {
        //Sys.println("DEBUG: function anySportApp.onStop()");
        if(self.oUpdateTimer != null) {
            (self.oUpdateTimer as Timer.Timer).stop();
            self.oUpdateTimer = null;
        }
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
         //Sys.println("DEBUG: function anySportApp.getInitialView()");
        _view = new anySportView();
        return [ _view, new anySportDelegate() ] as Array<Views or InputDelegates>;
    }

    function onUpdateTimer_init() as Void {
        //Sys.println("DEBUG: function anySportApp.onUpdateTimer_init()");
    }

    // Returns main view instance
    function getView() as anySportView {
        //Sys.println("DEBUG: function anySportApp.getViewInstance()");
        return _view;
    }
}

function getApp() as anySportApp {
    //Sys.println("DEBUG: function anySportApp.getApp()");
    return Application.getApp() as anySportApp;
}

// Returns main view
function getView() as anySportView {
    //Sys.println("DEBUG: function anySportApp.getViewMain()");
    return Application.getApp().getView();
}
