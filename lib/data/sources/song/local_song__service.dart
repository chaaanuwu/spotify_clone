import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';

abstract class SongLocalService {
  Future<Either> getNewsSongs();
}

class SongLocalServiceImpl extends SongLocalService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];

      var jsonData = await rootBundle.loadString('assets/data/songs.json');

      var data = jsonDecode(jsonData);

      for (var element in data) {
        var songModel = SongModel.fromJson(element);
        songs.add(songModel.toEntity());
      }

      songs.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));

      return Right(songs);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
