class CalendarEvent {
  final String title;
  final String nickname;
  final String startDate;

  const CalendarEvent(this.title, this.nickname, this.startDate);

  @override
  String toString() => title;
}

// final kEvents = LinkedHashMap<DateTime, List<CalendarEvent>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = {
//   for (var item in List.generate(50, (index) => index))
//     DateTime.utc(DateTime.now().year, DateTime.now().month, item * 5):
//         List.generate(item % 4 + 1,
//             (index) => CalendarEvent('Event $item | ${index + 1}'))
// }..addAll({
//     DateTime.now(): [
//       CalendarEvent('Today\'s Event 1'),
//       CalendarEvent('Today\'s Event 2'),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
