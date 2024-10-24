class PhotoMetadata {
  final String path;
  final DateTime timestamp;
  final String location;
  final String weather;
  final String description;

  PhotoMetadata({
    required this.path,
    required this.timestamp,
    required this.location,
    required this.weather,
    required this.description,
  });
}