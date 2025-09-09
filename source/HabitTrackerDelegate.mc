import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;

class HabitTrackerDelegate extends WatchUi.BehaviorDelegate {
    private var _view as HabitTrackerView?;

    function initialize() {
        BehaviorDelegate.initialize();
        _view = null;
    }

    function setView(view as HabitTrackerView) {
        _view = view;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            var app = Application.getApp() as HabitTrackerApp;
            app.toggleHabit(app.getSelectedIndex());
            if (Attention != null) {
                var vibe = new Attention.VibeProfile(50, 100);
                Attention.vibrate([vibe]);
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_UP) {
            if (_view != null) {
                _view.moveSelection(-1);
            }
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            if (_view != null) {
                _view.moveSelection(1);
            }
            return true;
        }
        return false;
    }
}