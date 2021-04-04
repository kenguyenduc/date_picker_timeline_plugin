import 'package:date_picker_timeline_plugin/gestures/tap.dart';
import 'package:date_picker_timeline_plugin/utils.dart';
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
  })  : assert(!lastDate.isBefore(firstDate),
            'lastDate $lastDate must be on or after firstDate $firstDate.'),
        assert(!initialDate.isBefore(firstDate),
            'initialDate $initialDate must be on or after firstDate $firstDate.'),
        assert(!initialDate.isAfter(lastDate),
            'initialDate $initialDate must be on or before lastDate $lastDate.'),
        super(key: key);

  final BuildContext context;

  /// Ngày khởi tạo được chon ban đầu
  final DateTime initialDate;

  /// ngày bắt đầu
  final DateTime firstDate;

  /// ngày cuối cùng
  final DateTime lastDate;

  /// Callback function for when a different date is selected
  final DateChangeListener? onDateChange;

  @override
  _DatePickerTimelineState createState() => _DatePickerTimelineState();
}

class _DatePickerTimelineState extends State<DatePickerTimeline> {
  static final DateTime _dateTimeNow = DateTime.now();

  late PageController _pageController;
  final GlobalKey _pageViewKey = GlobalKey();
  List<String> _dropdownItemsMonth = <String>[];
  String? _dropdownValueMonth;
  late DateTime _currentDisplayedMonthDate;
  DateTime? _selectedDate;
  bool _isFirstSelectedInitDate = true;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentDisplayedMonthDate = _dateTimeNow;
    _pageController = PageController(
        initialPage: Utils.monthDelta(widget.firstDate, _dateTimeNow));
    _pageController.addListener(_onPageScroll);
    _loadListMonthSelect();
    _focusedDay = widget.initialDate;
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

  // Widget _buildDaysOnWeek() {
  //   List<Widget> _widgets = <Widget>[];
  //   for (int i = 0; i < 7; i++) {
  //     _widgets.add(_buildItem());
  //   }
  //   return Row(
  //     children: _widgets,
  //   );
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 40),
  //     child: PageView.builder(
  //       key: _pageViewKey,
  //       controller: _pageController,
  //       onPageChanged: _handleWeekPageChanged,
  //       itemCount: Utils.monthDelta(widget.firstDate, widget.lastDate) + 1,
  //       itemBuilder: (BuildContext context, int index) => _buildItem(),
  //     ),
  //   );
  // }

  void _handleWeekPageChanged(int weekPage) {}
  bool _isOnHorizontalDragStart = false;

  Widget _buildDaysOnWeek() {
    List<Widget> _widgets = <Widget>[];
    DateTime _monday = Utils.getMondayOnCurrentWeek(_focusedDay);
    for (int i = 0; i < 7; i++) {
      _widgets.add(DateWidget(
        date: _monday.add(Duration(days: i)),
        count: i + 1,
        onDateSelected: (selectedDate) {
          if (widget.onDateChange != null) {
            widget.onDateChange!(selectedDate);
          }
          setState(() {
            _isFirstSelectedInitDate = false;
            _selectedDate = selectedDate;
          });
        },
        isSelected: Utils.isSameDay(
                _selectedDate, _focusedDay.add(Duration(days: i))) ||
            (_isFirstSelectedInitDate &&
                Utils.isSameDay(
                    _focusedDay, _dateTimeNow.add(Duration(days: i)))),
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Dismissible(
        key: UniqueKey(),
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            _handleNextWeek();
          } else if (direction == DismissDirection.startToEnd) {
            _handlePreviousWeek();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _widgets,
        ),
      ),
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
            icon: const Icon(
              Icons.chevron_right,
              color: Color(0xFF303030),
            ),
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
              Icons.chevron_left,
              color: Color(0xFF303030),
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
      // _pageController.nextPage(
      //     duration: _kMonthScrollDuration, curve: Curves.ease);
      setState(() {
        _focusedDay = _focusedDay.add(Duration(days: 7));
      });
    }
  }

  ///Load page view previous month
  void _handlePreviousWeek() {
    if (!_isDisplayingFirstMonth) {
      // _pageController.previousPage(
      //     duration: _kMonthScrollDuration, curve: Curves.ease);
      setState(() {
        _focusedDay = _focusedDay.subtract(Duration(days: 7));
      });
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
