class PhotoMetadata {
  final int? id;
  final String path;
  final String timestamp;
  final String description;
  final String location;
  final String weather;

  PhotoMetadata({
    this.id,
    required this.path,
    required this.timestamp,
    required this.description,
    required this.location,
    required this.weather,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'timestamp': timestamp,
      'description': description,
      'location': location,
      'weather': weather,
    };
  }

  factory PhotoMetadata.fromMap(Map<String, dynamic> map) {
    return PhotoMetadata(
      id: map['id'],
      path: map['path'],
      timestamp: map['timestamp'],
      description: map['description'],
      location: map['location'],
      weather: map['weather'],
    );
  }
}
