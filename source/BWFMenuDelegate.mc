import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using System as Sys;

class BWFMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        Sys.println("DEBUG: function BWFMenuDelegate.initialize()");
        MenuInputDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.Menu2({:title=>"Main Menu"});
        var delegate;
        menu.addItem(
            new MenuItem(
                "Label_1",
                "subLabel_1",
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
        delegate = new BWFDelegate(); // a WatchUi.Menu2InputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_UP);

        return true;
    }
}