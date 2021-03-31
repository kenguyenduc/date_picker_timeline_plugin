import 'package:date_picker_timeline_plugin/gestures/tap.dart';
import 'package:date_picker_timeline_plugin/widgets/dashed_line_horizontal.dart';
import 'package:flutter/material.dart';

import 'widgets/date_widget.dart';

const Duration _kMonthScrollDuration = Duration(milliseconds: 200);

class DatePickerTimeline extends StatefulWidget {
  DatePickerTimeline({
    Key? key,
    required this.context,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateChange,
  })   : assert(!lastDate.isBefore(firstDate),
            'lastDate $lastDate must be on or after firstDate $firstDate.'),
        assert(!initialDate.isBefore(firstDate),
            'initialDate $initialDate must be on or after firstDate $firstDate.'),
        assert(!initialDate.isAfter(lastDate),
            'initialDate $initialDate must be on or before lastDate $lastDate.'),
        super(key: key);

  final BuildContext context;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  /// Callback function for when a different date is selected
  final DateChangeListener? onDateChange;

  @override
  _DatePickerTimelineState createState() => _DatePickerTimelineState();
}

class _DatePickerTimelineState extends State<DatePickerTimeline> {
  late PageController _pageController;
  final GlobalKey _pageViewKey = GlobalKey();
  List<String> _dropdownItemsMonth = <String>[];
  String? _dropdownValueMonth;
  static final DateTime _dateTimeNow = DateTime.now();
  late DateTime _currentDisplayedMonthDate;
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDisplayedMonthDate = _dateTimeNow;
    _pageController = PageController(
        initialPage: DateUtils.monthDelta(widget.firstDate, _dateTimeNow));
    _pageController.addListener(_onPageScroll);
    _loadListMonthSelect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Handle update list item dropdown select month
  void _loadListMonthSelect() {
    _dropdownValueMonth = '${_dateTimeNow.month}, ${_dateTimeNow.year}';
    int _firstYear = widget.firstDate.year;
    int _lastYear = widget.lastDate.year;
    //Cập nhật tháng những năm trước
    for (int i = _firstYear; i < _lastYear; i++) {
      for (int j = 1; j <= 12; j++) _dropdownItemsMonth.add('$j, $i');
    }
    //Thêm tháng đến tháng hiện tại
    for (int i = 1; i <= widget.lastDate.month; i++) {
      _dropdownItemsMonth.add('$i, ${widget.lastDate.year}');
    }
  }

  void _onPageScroll() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          _buildDropdownSelectMoth(),
          const SizedBox(height: 6),
          DashedLineHorizontal(),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: Stack(
              children: <Widget>[
                _buildDaysOnWeek(),
                Align(
                    alignment: Alignment.centerRight,
                    child: _buildButtonNextPage()),
                Align(
                    alignment: Alignment.centerLeft,
                    child: _buildButtonPreviousPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelectMoth() {
    const TextStyle _textStyle = TextStyle(
      color: Color(0xFF303030),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Container(
      height: 19,
      padding: EdgeInsets.zero,
      child: DropdownButton<String>(
        value: _dropdownValueMonth,
        iconSize: 20,
        icon:
            Icon(Icons.keyboard_arrow_down_outlined, color: Color(0xFF303030)),
        elevation: 16,
        dropdownColor: Colors.white,
        style: _textStyle,
        underline: SizedBox(),
        onChanged: _handleDropdownMonthsChanged,
        items:
            _dropdownItemsMonth.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              'Tháng ' + value,
              style: _textStyle,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleDropdownMonthsChanged(String? value) {
    setState(() {
      _dropdownValueMonth = value;
    });
  }

  Widget _buildDaysOnWeek() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: PageView.builder(
        key: _pageViewKey,
        controller: _pageController,
        onPageChanged: _handleWeekPageChanged,
        itemCount: DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1,
        itemBuilder: (BuildContext context, int index) => _buildItems(),
      ),
    );
  }

  void _handleWeekPageChanged(int weekPage) {}

  Widget _buildItems() {
    List<Widget> _widgets = <Widget>[];
    for (int i = 0; i < 7; i++) {
      _widgets.add(DateWidget(
        date: _dateTimeNow,
        count: i + 1,
        onDateSelected: (selectedDate) {
          if (widget.onDateChange != null) {
            widget.onDateChange!(selectedDate);
          }
          setState(() {
            _currentDate = selectedDate;
          });
        },
        isSelected: DateUtils.isSameDay(_currentDate,_dateTimeNow),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _widgets,
    );
  }

  Widget _buildButtonNextPage() {
    return ClipOval(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: Color(0xFF303030), size: 20),
            onPressed: _handleNextWeek,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonPreviousPage() {
    return ClipOval(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF303030),
              size: 20,
            ),
            onPressed: _handlePreviousWeek,
          ),
        ),
      ),
    );
  }

  ///Load page view next month
  void _handleNextWeek() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
          duration: _kMonthScrollDuration, curve: Curves.ease);
    }
  }

  ///Load page view previous month
  void _handlePreviousWeek() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
          duration: _kMonthScrollDuration, curve: Curves.ease);
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentDisplayedMonthDate
        .isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentDisplayedMonthDate
        .isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));
  }
}
