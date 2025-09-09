import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class HabitTrackerApp extends Application.AppBase {
    private var _habits as Array<String> = [
        "Take Vitamins",
        "Take Creatine",
        "Workout",
        "Learn 30min",
        "Meditate"
    ];
    private var _progress as Array<Number>;
    private var _selectedIndex as Number = 0;

    function initialize() {
        AppBase.initialize();
        _progress = new Array<Number>[5];
        resetProgress();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        checkAndResetForNewDay();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        saveProgress();
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new HabitTrackerView();
        var delegate = new HabitTrackerDelegate();
        delegate.setView(view);
        return [view, delegate];
    }

    function resetProgress() {
        for (var i = 0; i < 5; i++) {
            _progress[i] = 0;
        }
    }

    function saveProgress() {
        var storage = {};
        for (var i = 0; i < _progress.size(); i++) {
            storage.put(i, _progress[i]);
        }
        storage.put(5, getCurrentDateString());
        Application.Storage.setValue("habits", storage);
    }

    function checkAndResetForNewDay() {
        var storage = Application.Storage.getValue("habits");
        if (storage != null) {
            var savedDate = storage.get(5);
            if (savedDate != getCurrentDateString()) {
                resetProgress();
            } else {
                for (var i = 0; i < 5; i++) {
                    _progress[i] = storage.get(i);
                }
            }
        }
    }

    function getCurrentDateString() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return Lang.format("$1$-$2$-$3$", [
            today.year,
            today.month.format("%02d"),
            today.day.format("%02d")
        ]);
    }

    function getHabits() {
        return _habits;
    }

    function getProgress() {
        return _progress;
    }

    function incrementHabit(index as Number) {
        if (_progress[index] < 1) {
            _progress[index] = 1;
            saveProgress();
        }
    }

    function toggleHabit(index as Number) {
        if (_progress[index] >= 1) {
            _progress[index] = 0;
        } else {
            _progress[index] = 1;
        }
        saveProgress();
    }

    function getSelectedIndex() {
        return _selectedIndex;
    }

    function setSelectedIndex(index as Number) {
        _selectedIndex = index;
    }

    function getCompletedCount() {
        var count = 0;
        for (var i = 0; i < _progress.size(); i++) {
            if (_progress[i] >= 1) {
                count++;
            }
        }
        return count;
    }
}

function getApp() as HabitTrackerApp {
    return Application.getApp() as HabitTrackerApp;
}