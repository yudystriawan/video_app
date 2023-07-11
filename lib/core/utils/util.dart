double valueFromPercentageInRange(
    {required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

/// return 0..1
double percentageFromDuration(
  Duration value,
  Duration minValue,
  Duration maxValue,
) {
  if (minValue == maxValue) {
    return 0.0;
  }

  double normalizedValue =
      (value - minValue).inMilliseconds / (maxValue - minValue).inMilliseconds;
  return normalizedValue;
}

extension DurationX on Duration {
  /// convert to hh:mm:ss
  String formatDuration() {
    String hours = (inHours % 24).toString().padLeft(2, '0');
    String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (inSeconds % 60).toString().padLeft(2, '0');

    String formattedDuration = '';
    if (inHours > 0) {
      formattedDuration += '$hours:';
    }
    formattedDuration += '$minutes:$seconds';

    return formattedDuration;
  }
}
