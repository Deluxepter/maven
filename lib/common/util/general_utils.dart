String workoutDuration(DateTime startTime) {
  Duration difference = DateTime.now().difference(startTime);
  int hours = difference.inHours;
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;
  if (hours == 0) {
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

String secondsToTime(int seconds) {
  int hours = (seconds / 3600).floor();
  int minutes = ((seconds % 3600) / 60).floor();
  int remainingSeconds = seconds % 60;
  String time = "";
  if(hours != 0) {
    time += "$hours:";
  }
  if(minutes < 10) {
    time += "$minutes:";
  } else {
    time += "$minutes:";
  }
  if(remainingSeconds < 10) {
    time += "0$remainingSeconds";
  } else {
    time += "$remainingSeconds";
  }
  return time;
}

String removeDecimalZeroFormat(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}
