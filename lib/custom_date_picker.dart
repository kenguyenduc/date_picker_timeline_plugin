import 'package:date_picker_timeline_plugin/date_time_range_select.dart';
import 'package:date_picker_timeline_plugin/utils.dart';
import 'package:flutter/material.dart';
import 'gestures/tap.dart';
import 'widgets/dashed_line_horizontal.dart';
import 'widgets/date_widget.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker({
    Key? key,
    required this.context,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.isShowDateTimeRange = false,
    this.onShowDateTimeRangeChange,
    this.onDateChange,
    this.onDateTimeRangeChanged,
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

  ///set trạng thái ban đầu
  ///chọn range ngày theo tháng OR chọn từng ngày theo tuần
  final bool isShowDateTimeRange;

  ///Check kiểu calendar thay đổi
  final ValueChanged<bool>? onShowDateTimeRangeChange;

  /// Ngày khởi tạo được chon ban đầu
  final DateTime initialDate;

  /// ngày bắt đầu của lich
  final DateTime firstDate;

  /// ngày cuối cùng của lich
  final DateTime lastDate;

  /// Ngày trong tuần đang được hiển thị
  final DateTime focusedDay;

  /// Callback function for when a different date is selected
  final DateChangeListener? onDateChange;

  /// Called when the user picks a month.
  final ValueChanged<DateTimeRange>? onDateTimeRangeChanged;

  ///ngày trong tuần hiển thị thay được thay đổi
  final DateChangeListener onFocusedDateChange;

  /// Count lịch hẹn các ngày trong tuần
  final List<int>? counts;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  static final DateTime _dateTimeNow = DateTime.now();

  /// Items dropdown button select month
  late String? _textFocusedMonth;

  ///Ngày được chọn
  late DateTime _selectedDate;

  /// Ngày trong tuần đang được hiển thị
  late DateTime _focusedDay;

  late bool _isShowDateTimeRange;

  final GlobalKey<DateTimeRangeSelectState> _keyDateTimeRange =
      GlobalKey<DateTimeRangeSelectState>();

  @override
  void initState() {
    super.initState();
    _isShowDateTimeRange = widget.isShowDateTimeRange;
    _textFocusedMonth = '${_dateTimeNow.month}, ${_dateTimeNow.year}';
    _selectedDate = widget.initialDate;
    _focusedDay = widget.focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isShowDateTimeRange != widget.isShowDateTimeRange) {
      _isShowDateTimeRange = widget.isShowDateTimeRange;
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
          _buildHeader(),
          const SizedBox(height: 10),
          const DashedLineHorizontal(color: Color(0xFFEEEEEE)),
          if (!_isShowDateTimeRange)
            _buildDateTimelineSelect()
          else
            _buildDateTimeRangeSelect(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Visibility(
            visible: _isShowDateTimeRange,
            child: _buildButtonPreviousMonth(),
          ),
          _buildTextButtonCurrentMonth(),
          Visibility(
            visible: _isShowDateTimeRange,
            child: _buildButtonNextMonth(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimelineSelect() {
    return SizedBox(
      height: 80,
      child: Stack(
        children: <Widget>[
          _buildDaysOnWeek(),
          Align(
              alignment: Alignment.centerRight, child: _buildButtonNextPage()),
          Align(
              alignment: Alignment.centerLeft,
              child: _buildButtonPreviousPage()),
        ],
      ),
    );
  }

  Widget _buildDateTimeRangeSelect() {
    ///
    ///Todo: scroll show date range picker
    ///
    return GestureDetector(
      // onVerticalDragDown: (details) {
      //   print('onVerticalDragDown');
      //   print(details);
      //   _handleTextCurrentMonthPressed();
      // },
      // onVerticalDragStart: (details) {
      //   print('onVerticalDragStart');
      //   print(details);
      //   // _handleTextCurrentMonthPressed();
      // },
      // onVerticalDragUpdate: (details) {
      //   print('onVerticalDragUpdate');
      //   print(details.primaryDelta);
      //   if(details.primaryDelta!=null && details.primaryDelta! < 0){
      //     // _handleTextCurrentMonthPressed();
      //   }
      // },
      onVerticalDragEnd: (details) {
        print('onVerticalDragEnd');
        print(details.primaryVelocity);
        // _handleTextCurrentMonthPressed();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DateTimeRangeSelect(
            key: _keyDateTimeRange,
            context: context,
            initialSelectedFirstDate: _focusedDay,
            initialSelectedLastDate: _focusedDay,
            focusedMonth: _focusedDay,
            onFocusedDateChange: (DateTime date) {
              setState(() {
                _focusedDay = date;
                widget.onFocusedDateChange(Utils.dateOnly(_focusedDay));
                _textFocusedMonth = '${date.month}, ${date.year}';
              });
            },
            onChanged: (DateTimeRange value) {
              if (widget.onDateTimeRangeChanged != null) {
                widget.onDateTimeRangeChanged!(value);
              }
            },
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color(0xFFCCCCCC),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _handleTextCurrentMonthPressed() {
    setState(() {
      _isShowDateTimeRange = !_isShowDateTimeRange;
      if (widget.onShowDateTimeRangeChange != null) {
        widget.onShowDateTimeRangeChange!(_isShowDateTimeRange);
      }
    });
  }

  Widget _buildTextButtonCurrentMonth() {
    return TextButton(
      onPressed: _handleTextCurrentMonthPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tháng $_textFocusedMonth',
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_isShowDateTimeRange)
            const SizedBox(width: 20)
          else
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF303030),
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildButtonNextMonth() {
    return ClipOval(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              if (_keyDateTimeRange.currentState != null) {
                _keyDateTimeRange.currentState!.handleNextMonth();
              }
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF303030),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonPreviousMonth() {
    return ClipOval(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              if (_keyDateTimeRange.currentState != null) {
                _keyDateTimeRange.currentState!.handlePreviousMonth();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF303030),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// convert 'stringMonth, stringYear' to DateTime
  DateTime _getValueToDate(String value) {
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
        isCurrentMonth:
            Utils.isSameMonth(_date, _getValueToDate(_textFocusedMonth!)),
        onDateSelected: (DateTime selectedDate) {
          if (widget.onDateChange != null) {
            widget.onDateChange!(Utils.dateOnly(selectedDate));
          }
          setState(() {
            _selectedDate = selectedDate;
            _focusedDay = _selectedDate;
            _textFocusedMonth = '${_focusedDay.month}, ${_focusedDay.year}';
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
            icon: const Icon(
              Icons.keyboard_arrow_right_outlined,
              color: Color(0xFF858585),
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
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Color(0xFF858585),
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
        _textFocusedMonth = '${_focusedDay.month}, ${_focusedDay.year}';
      });
    }
  }

  ///Load page view previous month
  void _handlePreviousWeek() {
    if (!_isDisplayingFirstMonth) {
      setState(() {
        _focusedDay = _focusedDay.subtract(const Duration(days: 7));
        widget.onFocusedDateChange(Utils.dateOnly(_focusedDay));
        _textFocusedMonth = '${_focusedDay.month}, ${_focusedDay.year}';
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
