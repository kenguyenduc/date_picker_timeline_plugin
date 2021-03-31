import 'package:date_picker_timeline_plugin/widgets/dashed_line_horizontal.dart';
import 'package:flutter/material.dart';

class DatePickerTimeline extends StatefulWidget {
  DatePickerTimeline({
    Key? key,
    required this.context,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
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

  @override
  _DatePickerTimelineState createState() => _DatePickerTimelineState();
}

class _DatePickerTimelineState extends State<DatePickerTimeline> {
  final PageController _pageController = PageController();
  List<String> _dropdownItemsMonth = <String>[];
  String? _dropdownValueMonth;
  final DateTime _dateTimeNow = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
    _loadListMonthSelect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Handle update list item dropdown select month
  void _loadListMonthSelect() {
    _dropdownValueMonth = '${_dateTimeNow.month}/${_dateTimeNow.year}';
    int _firstYear = widget.firstDate.year;
    int _lastYear = widget.lastDate.year;
    //Cập nhật tháng những năm trước
    for (int i = _firstYear; i < _lastYear; i++) {
      for (int j = 1; j <= 12; j++) _dropdownItemsMonth.add('$j/$i');
    }
    //Thêm tháng đến tháng hiện tại
    for (int i = 1; i <= widget.lastDate.month; i++) {
      _dropdownItemsMonth.add('$i/${widget.lastDate.year}');
    }
  }

  void _onPageScroll() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildDropdownSelectMoth(),
          DashedLineHorizontal(),
          // Stack(
          //   children: <Widget>[
          //     _buildDaysOnWeek(),
          //     Align(
          //         alignment: Alignment.centerRight,
          //         child: _buildButtonNextPage()),
          //     Align(
          //         alignment: Alignment.centerLeft,
          //         child: _buildButtonPreviousPage()),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelectMoth() {
    return Container(
      height: 19,
      padding: EdgeInsets.zero,
      child: DropdownButton<String>(
        value: _dropdownValueMonth,
        iconSize: 24,
        elevation: 16,
        dropdownColor: Colors.white,
        style: TextStyle(color: Color(0xFF2C333A)),
        underline: SizedBox(),
        onChanged: _handleDropdownMonthsChanged,
        items:
            _dropdownItemsMonth.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              'Tháng ' + value,
              style: TextStyle(fontSize: 15, color: Color(0xFF2C333A)),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleDropdownMonthsChanged(String? value) {
    showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate)
    setState(() {
      _dropdownValueMonth = value;
    });
  }

  Widget _buildDaysOnWeek() {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) => Container(),
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
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF303030)),
            onPressed: () {},
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
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF303030)),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
