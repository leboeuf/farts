class Tick {
  final DateTime timestamp;
  final double open, high, low, close;
  final int volume;

  const Tick(
    this.timestamp,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
  );
}
