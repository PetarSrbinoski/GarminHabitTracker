import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class HabitTrackerView extends WatchUi.View {
    private var _fontHeight as Number = 0;
    private var _itemHeight as Number = 0;
    private var _colors as Array<Number> = [
        0x00E676,  
        0xFF5252,  
        0x448AFF,  
        0xFF9800   
    ];
    private var _pageIndex as Number = 0;

    function initialize() {
        View.initialize();
    }

    
    function onLayout(dc as Dc) as Void {
        _fontHeight = dc.getFontHeight(Graphics.FONT_MEDIUM);
        _itemHeight = _fontHeight + 8; 
    }

    
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (_pageIndex == 0) {
            var app = Application.getApp() as HabitTrackerApp;
            var progress = app.getProgress();
            var selectedIndex = app.getSelectedIndex();

            var emojis = ["D3", "Zn", "Om", "B", "Mg"];

            var cols = 2;
            var rows = 3;
            var cellW = (dc.getWidth() - 40) / cols;
            var cellH = (dc.getHeight() - 60) / rows;
            var iconSize = cellH * 0.5;

            
            for (var i = 0; i < 6; i++) {
                var col = i % cols;
                var row = (i / cols).toNumber();
                var x = 20 + col * cellW;
                var y = 30 + row * cellH;

                var fieldCenterX = x + (cellW-10)/2;
                var fieldCenterY = y + (cellH-10)/2;
                var fieldRadius = ((cellW-10) < (cellH-10) ? (cellW-10) : (cellH-10)) / 2 - 4;

                if (i < 5) {
                    var borderColor;
                    if (i == selectedIndex) {
                        borderColor = _colors[2];
                    } else if (progress[i] >= 1) {
                        borderColor = _colors[0];
                    } else {
                        borderColor = Graphics.COLOR_WHITE;
                    }
                    dc.setColor(borderColor, Graphics.COLOR_TRANSPARENT);
                    dc.setPenWidth(4);
                    dc.drawCircle(fieldCenterX, fieldCenterY, fieldRadius);
                    dc.setPenWidth(1);
                }

                if (i < 5) {
                
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(fieldCenterX, fieldCenterY, Graphics.FONT_LARGE, emojis[i], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

                    if (progress[i] >= 1) {
                        dc.setColor(_colors[0], Graphics.COLOR_TRANSPARENT);
                        drawCheckmark(dc, fieldCenterX, (fieldCenterY + iconSize/2 + 8).toNumber());
                    }
                } else {

                    var completed = app.getCompletedCount();
                    var barW = cellW-30;
                    var barH = 14;
                    var barX = x + 15;
                    var barY = y + (cellH-10)/2 - barH/2;

                    var barColor = (completed == 5) ? _colors[0] : _colors[3];
                    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                    dc.fillRoundedRectangle(barX, barY, barW, barH, barH/2);
                    dc.setColor(0x222222, Graphics.COLOR_TRANSPARENT);
                    dc.drawRoundedRectangle(barX, barY, barW, barH, barH/2);
                    if (completed > 0) {
                        dc.setColor(barColor, Graphics.COLOR_TRANSPARENT);
                        dc.fillRoundedRectangle(barX, barY, (completed * barW / 5).toNumber(), barH, barH/2);
                    }

                }
            }
        } else {
            
            var app = Application.getApp() as HabitTrackerApp;
            var history = app.getHistoryWithToday();
            var barMax = 5;
            var barCount = history.size();
            if (barCount == 1) {
                history = [history[0]];
                barCount = 1;
            }
            var graphW = dc.getWidth() - 80;
            var graphH = 100;
            var barW = graphW / (barCount > 0 ? barCount : 1);
            var centerY = dc.getHeight()/2;
            var baseY = centerY + graphH/2;
            var topY = 40;
            
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, topY, Graphics.FONT_SMALL, "Last 7 Days", Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(40, baseY, 40 + graphW, baseY);
            
            for (var i = 0; i < barCount; i++) {
                var val = history[i];
                if (val < 0) { val = 0; }
                if (val > barMax) { val = barMax; }
                var x = 40 + i * barW + barW/4;
                var h = (val * graphH / barMax).toNumber();
                if (h < 0) { h = 0; }
                var y = baseY - h;
                
                if (i > 0) {
                    var fadedColor = 0xAAD8FF;
                    dc.setColor(fadedColor, Graphics.COLOR_TRANSPARENT);
                    dc.setPenWidth(2);
                    
                    var dotYStart = baseY - graphH + 10;
                    var dotYEnd = baseY + 10;
                    for (var dotY = dotYStart; dotY < dotYEnd; dotY += 6) {
                        dc.drawLine(x - barW/4, dotY, x - barW/4, dotY + 2);
                    }
                    dc.setPenWidth(1);
                }
                
                var barColor = (val == barMax) ? _colors[0] : _colors[3];
                dc.setColor(barColor, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(x, y, barW/2, h, 6);
                
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x + barW/4, baseY + 18, Graphics.FONT_MEDIUM, val.toString(), Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
    }

    function drawCheckmark(dc as Dc, x as Number, y as Number) as Void {
        var size = 8;
        dc.setPenWidth(2);
        dc.drawLine(x-size/2, y, x, y+size/2);
        dc.drawLine(x, y+size/2, x+size/2, y-size/2);
        dc.setPenWidth(1);
    }

    function drawModernProgressBar(dc as Dc, x as Number, y as Number, width as Number, height as Number, percentage as Number) as Void {

        dc.setColor(0x333333, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x, y, width, height, height/2);
        

        if (percentage > 0) {
            dc.setColor(_colors[3], Graphics.COLOR_TRANSPARENT);
            var progressWidth = (percentage * width / 100).toNumber();
            dc.fillRoundedRectangle(x, y, progressWidth, height, height/2);
            

            dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x + progressWidth - 2, y + 2, x + progressWidth - 2, y + height - 2);
        }
    }

    function drawModernCheckmark(dc as Dc, x as Number, y as Number) as Void {
        var size = 6;

        dc.setPenWidth(2);
        dc.drawLine(x-size, y, x-size/2, y+size);
        dc.drawLine(x-size/2, y+size, x+size, y-size);
        dc.setPenWidth(1);
    }

    function drawProgressCircle(dc as Dc, x as Number, y as Number, radius as Number, color as Number) as Void {

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(x, y, radius);
        

        dc.fillCircle(x, y, 2);
    }

    function drawGradientShadow(dc as Dc, y as Number, isTop as Boolean) as Void {
        var height = 8;
        for(var i = 0; i < height; i++) {
            var alpha = (i * 255 / height).toNumber();
            dc.setColor(Graphics.COLOR_BLACK | alpha, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(0, isTop ? y + i : y - i, dc.getWidth(), isTop ? y + i : y - i);
        }
    }

    function moveSelection(move as Number) {
        var app = Application.getApp() as HabitTrackerApp;
        var currentIndex = app.getSelectedIndex();
        var newIndex = (currentIndex + move) % 5;
        if (newIndex < 0) {
            newIndex = 4;
        }
        app.setSelectedIndex(newIndex);
        WatchUi.requestUpdate();
    }

    function setPageIndex(idx as Number) {
        _pageIndex = idx;
    }
    function getPageIndex() as Number {
        return _pageIndex;
    }
}

