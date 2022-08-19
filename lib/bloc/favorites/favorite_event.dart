
import 'package:flutter/material.dart';

@immutable
abstract class FavoriteEvent {}

class FavoriteListFetched extends FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {}
class ArchiveDataItem extends FavoriteEvent{}


