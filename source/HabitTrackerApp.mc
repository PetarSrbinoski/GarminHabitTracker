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
    private var _history as Array<Number> = new Array<Number>[0];

    function initialize() {
        AppBase.initialize();
        _progress = new Array<Number>[5];
        
        _history = new Array<Number>[0];
    }

    function onStart(state as Dictionary?) as Void {
        checkAndResetForNewDay();
    }

    
    function onStop(state as Dictionary?) as Void {
        saveProgress();
    }

    
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new HabitTrackerView();
        var delegate = new HabitTrackerDelegate();
        delegate.setView(view);
        return [view, delegate];
    }

    function getCurrentDayNumber() {
        var now = Time.now();
        var daysSinceEpoch = now.value() / (24 * 60 * 60); 
        return daysSinceEpoch.toNumber(); 
    }

    function saveProgress() {
        var storage = {};
        for (var i = 0; i < _progress.size(); i++) {
            storage.put(i, _progress[i]);
        }
        storage.put(100, getCurrentDateString());
        storage.put(300, getCurrentDayNumber()); 
        storage.put(200, _history.size());
        for (var i = 0; i < _history.size(); i++) {
            storage.put(201 + i, _history[i]);
        }
        Application.Storage.setValue("habits", storage);
    }

    function checkAndResetForNewDay() {
        var storage = Application.Storage.getValue("habits");
        var todayDayNumber = getCurrentDayNumber();
        
        if (storage != null) {
            var lastSavedDayNumber = storage.get(300); 
            var historySize = storage.get(200);
            if (historySize == null) { historySize = 0; }
           
            var loadedHistory = new Array<Number>[historySize];
            for (var i = 0; i < historySize; i++) {
                var histVal = storage.get(201 + i);
                loadedHistory[i] = (histVal == null) ? 0 : histVal;
            }
            _history = loadedHistory;
       
       
            for (var i = 0; i < 5; i++) {
                var v = storage.get(i);
                _progress[i] = (v == null) ? 0 : v;
            }
            
            if (lastSavedDayNumber != null && lastSavedDayNumber < todayDayNumber) {
                var yesterdayCount = 0;
                for (var i = 0; i < 5; i++) {
                    if (_progress[i] >= 1) { 
                        yesterdayCount++; 
                    }
                }
                
                _history.add(yesterdayCount);
                
                if (_history.size() > 6) {
                    var newHist = new Array<Number>[6];
                    var startIdx = _history.size() - 6;
                    for (var i = 0; i < 6; i++) { 
                        newHist[i] = _history[startIdx + i]; 
                    }
                    _history = newHist;
                }
                
                for (var i = 0; i < 5; i++) { 
                    _progress[i] = 0; 
                }
                
                saveProgress();
            }
            
        } else {
            _progress = new Array<Number>[5];
            for (var i = 0; i < 5; i++) { 
                _progress[i] = 0; 
            }
            _history = new Array<Number>[0];
            saveProgress();
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

    function getHistoryWithToday() as Array<Number> {
        var histWithToday = new Array<Number>[_history.size() + 1];
        for (var i = 0; i < _history.size(); i++) { 
            histWithToday[i] = _history[i]; 
        }
        histWithToday[_history.size()] = getCompletedCount();
        
        if (histWithToday.size() > 7) {
            var last7 = new Array<Number>[7];
            for (var i = 0; i < 7; i++) { 
                last7[i] = histWithToday[histWithToday.size() - 7 + i]; 
            }
            return last7;
        }
        return histWithToday;
    }

    function resetProgress() {
        for (var i = 0; i < 5; i++) {
            _progress[i] = 0;
        }
        saveProgress();
    }

    function toggleHabit(index as Number) {
        if (_progress[index] >= 1) {
            _progress[index] = 0;
        } else {
            _progress[index] = 1;
        }
        saveProgress();
    }
}

function getApp() as HabitTrackerApp {
    return Application.getApp() as HabitTrackerApp;
}