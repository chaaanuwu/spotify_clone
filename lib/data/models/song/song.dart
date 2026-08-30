import 'package:spotify_clone/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  double? duration;
  String? releaseDate;
  String? coverPath;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.coverPath,
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'];
    coverPath = data['coverPath'];
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title!,
      artist: artist!,
      duration: duration!,
      releaseDate: releaseDate!,
      coverPath: coverPath!,
    );
  }
}
