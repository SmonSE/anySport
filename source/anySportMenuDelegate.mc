import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using System as Sys;

class anySportMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        Sys.println("DEBUG: function anySportMenuDelegate.initialize()");
        MenuInputDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.Menu2({:title=>"Main Menu"});
        var delegate;
        menu.addItem(
            new MenuItem(
                "GPS",
                "ON/OFF",
                "itemOneId",
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                "Label_2",
                "subLabel_2",
                "itemTwoId",
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                "Back",
                "Main View",
                "itemThreeId",
                {}
            )
        );
        delegate = new anySportDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_UP);

        return true;
    }
}
