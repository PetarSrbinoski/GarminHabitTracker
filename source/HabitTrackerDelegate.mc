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
            if (_view != null && _view.getPageIndex() == 0) {
                var app = Application.getApp() as HabitTrackerApp;
                app.toggleHabit(app.getSelectedIndex());
                if (Attention != null) {
                    var vibe = new Attention.VibeProfile(50, 100);
                    Attention.vibrate([vibe]);
                }
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_UP) {
            if (_view != null && _view.getPageIndex() == 0) {
                var app = Application.getApp() as HabitTrackerApp;
                var idx = app.getSelectedIndex();
                idx = (idx + 1) % 5;
                app.setSelectedIndex(idx);
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            if (_view != null) {
                var nextPage = (_view.getPageIndex() == 0) ? 1 : 0;
                _view.setPageIndex(nextPage);
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_LEFT) {
            if (_view != null) {
                _view.setPageIndex(0);
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_RIGHT) {
            if (_view != null) {
                _view.setPageIndex(1);
                WatchUi.requestUpdate();
            }
            return true;
        }
        return false;
    }
}