import "package:intl/intl.dart";

String formatDeadline(DateTime date) {
  final format = date.year == DateTime.now().year
      ? DateFormat.MMMEd()
      : DateFormat.yMMMEd();
  return format.format(date);
}
