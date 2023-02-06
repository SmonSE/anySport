import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using System as Sys;

class anySportMenuADelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
    MenuInputDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.CheckboxMenu({:title=>"Main Menu"});
        var delegate;
        menu.addItem(
            new CheckboxMenuItem(
                "GPS",
                "ON/OFF",
                "itemGpsId",
                DataManager.getGPS(),
                {}
            )
        );
        delegate = new anySportDelegate();   
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_UP);

        return true;
    }
}