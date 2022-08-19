
import 'package:flutter/material.dart';

@immutable
abstract class NotesEvent {}

class NotesListFetched extends NotesEvent {}

class AddToNote extends NotesEvent {}
class ArchiveDataItem extends NotesEvent{}


