
import 'package:flutter/material.dart';

@immutable
abstract class BanisEvent {}

class BanisFetched extends BanisEvent {}
class SearchBanisFetched extends BanisEvent {}
