import 'package:intl/intl.dart';

String getFormattedDate(DateTime dt, {String pattern = 'EEE MMM dd/yyyy'}) {
  return DateFormat(pattern).format(dt);
}
