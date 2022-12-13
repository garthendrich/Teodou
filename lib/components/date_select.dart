import "package:flutter/material.dart";

class DateSelect extends StatefulWidget {
  final Function(DateTime) onChanged;

  const DateSelect({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButton(
            hint: const Text("Month"),
            value: _months[_selectedDate.month - 1],
            onChanged: (selectedMonth) {
              setState(() {
                final month = _months.indexOf(selectedMonth!) + 1;
                updateSelectedDate(month: month);
              });
            },
            items: _months.map((birthMonth) {
              return DropdownMenuItem(
                value: birthMonth,
                child: Text(birthMonth),
              );
            }).toList(),
            isExpanded: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton(
            hint: const Text("Day"),
            value: _selectedDate.day,
            onChanged: (selectedDay) {
              setState(() => updateSelectedDate(day: selectedDay));
            },
            items: List.generate(31, (number) {
              return DropdownMenuItem(
                value: number + 1,
                child: Text((number + 1).toString()),
              );
            }),
            isExpanded: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton(
            hint: const Text("Year"),
            value: _selectedDate.year,
            onChanged: (selectedYear) {
              setState(() => updateSelectedDate(year: selectedYear));
            },
            items: List.generate(150, (number) {
              return DropdownMenuItem(
                value: DateTime.now().year - number,
                child: Text((DateTime.now().year - number).toString()),
              );
            }),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  updateSelectedDate({int? year, int? month, int? day}) {
    _selectedDate = DateTime(
      year ?? _selectedDate.year,
      month ?? _selectedDate.month,
      day ?? _selectedDate.day,
    );

    widget.onChanged(_selectedDate);
  }
}
