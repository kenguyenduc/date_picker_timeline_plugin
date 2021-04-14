import 'package:date_picker_timeline_plugin/utils.dart';
import 'package:flutter/material.dart';
import 'gestures/tap.dart';
import 'widgets/dashed_line_horizontal.dart';
import 'widgets/date_widget.dart';

class DatePickerTimeline extends StatefulWidget {
  DatePickerTimeline({
    Key? key,
    required this.context,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateChange,
    required this.onFocusedDateChange,
    required this.focusedDay,
    this.counts,
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

  /// Ngày trong tuần đang được hiển thị
  final DateTime focusedDay;

  /// Callback function for when a different date is selected
  final DateChangeListener? onDateChange;

  ///ngày trong tuần hiển thị thay được thay đổi
  final DateChangeListener onFocusedDateChange;

  /// Count lịch hẹn các ngày trong tuần
  final List<int>? counts;

  @override
  _DatePickerTimelineState createState() => _DatePickerTimelineState();
}

class _DatePickerTimelineState extends State<DatePickerTimeline> {
  static final DateTime _dateTimeNow = DateTime.now();

  /// Items dropdown button select month
  final List<String> _dropdownItemsMonth = <String>[];
  late String? _dropdownValueMonth;

  ///Ngày được chọn
  late DateTime _selectedDate;

  /// Ngày trong tuần đang được hiển thị
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _loadListMonthSelect();
    _selectedDate = widget.initialDate;
    _focusedDay = widget.focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Handle update list item dropdown select month
  void _loadListMonthSelect() {
    _dropdownValueMonth = '${_dateTimeNow.month}, ${_dateTimeNow.year}';
    final int _firstYear = widget.firstDate.year;
    final int _lastYear = widget.lastDate.year;
    //Cập nhật tháng những năm trước
    for (int i = _firstYear; i < _lastYear; i++) {
      for (int j = 1; j <= 12; j++) {
        _dropdownItemsMonth.add('$j, $i');
      }
    }
    //Thêm tháng đến tháng hiện tại
    for (int i = 1; i <= widget.lastDate.month; i++) {
      _dropdownItemsMonth.add('$i, ${widget.lastDate.year}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          _buildDropdownSelectMoth(),
          const SizedBox(height: 12),
          const DashedLineHorizontal(color: Color(0xFFEEEEEE)),
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
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: const Color(0xFF303030),
        ),
        elevation: 16,
        dropdownColor: Colors.white,
        style: _textStyle,
        isDense: false,
        underline: const SizedBox.shrink(),
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
      final List<String> _times = _dropdownValueMonth!.split(', ');
      _focusedDay = DateTime(int.parse(_times[1]), int.parse(_times[0]), 1);
    });
  }

  DateTime _fromDropdownValueToDate(String value) {
    final List<String> _monthYear = value.split(', ');
    return DateTime(int.parse(_monthYear[1]), int.parse(_monthYear[0]));
  }

  Widget _buildDaysOnWeek() {
    final List<Widget> _widgets = <Widget>[];
    final DateTime _monday = Utils.getMondayOnCurrentWeek(_focusedDay);
    for (int i = 0; i < 7; i++) {
      final DateTime _date = _monday.add(Duration(days: i));
      _widgets.add(DateWidget(
        date: _date,
        count: widget.counts != null ? widget.counts![i] : 0,
        isCurrentMonth: Utils.isSameMonth(
            _date, _fromDropdownValueToDate(_dropdownValueMonth!)),
        onDateSelected: (DateTime selectedDate) {
          if (widget.onDateChange != null) {
            widget.onDateChange!(Utils.dateOnly(selectedDate));
          }
          setState(() {
            _selectedDate = selectedDate;
            _focusedDay = _selectedDate;
            _dropdownValueMonth = '${_focusedDay.month}, ${_focusedDay.year}';
          });
        },
        isSelected: Utils.isSameDay(
          _selectedDate,
          _date,
        ),
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
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _widgets,
          ),
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
            icon: Icon(
              Icons.keyboard_arrow_right_outlined,
              color: const Color(0xFF858585),
            ),
            onPressed: () {
              _handleNextWeek();
            },
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
            icon: Icon(
              Icons.keyboard_arrow_left_outlined,
              color: const Color(0xFF858585),
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
      setState(() {
        _focusedDay = _focusedDay.add(const Duration(days: 7));
        widget.onFocusedDateChange(Utils.dateOnly(_focusedDay));
        _dropdownValueMonth = '${_focusedDay.month}, ${_focusedDay.year}';
      });
    }
  }

  ///Load page view previous month
  void _handlePreviousWeek() {
    if (!_isDisplayingFirstMonth) {
      setState(() {
        _focusedDay = _focusedDay.subtract(const Duration(days: 7));
        widget.onFocusedDateChange(Utils.dateOnly(_focusedDay));
        _dropdownValueMonth = '${_focusedDay.month}, ${_focusedDay.year}';
      });
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_focusedDay
        .isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_focusedDay
        .isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));
  }
}
