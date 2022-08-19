import 'package:learn_shudh_gurbani/models/create_reminders_data.dart';
import 'package:learn_shudh_gurbani/models/favorite_data_item.dart';
import 'package:learn_shudh_gurbani/models/note_data_item.dart';
import 'package:learn_shudh_gurbani/models/app_info_data.dart';
import 'package:learn_shudh_gurbani/models/banis.dart';
import 'package:learn_shudh_gurbani/models/folder_model.dart';
import 'package:learn_shudh_gurbani/models/gutkas.dart';
import 'package:learn_shudh_gurbani/models/pothi_sahib_data.dart';
import 'package:learn_shudh_gurbani/models/shabad.dart';
import 'package:learn_shudh_gurbani/models/trackers_data.dart';
import '../models/raag_data.dart';
import '../models/sources.dart';
import '../models/writers.dart';
import '../strings.dart';
import '../utils/database_handler.dart';

class Repository{

  @override
  Future<List<RaagModel>> fetchRaagList() {
    return DatabaseHandler.instance.getRaagList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<WritersModel>> fetchWriterList() {
    return DatabaseHandler.instance.getWritersList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<SourcesModel>> fetchSourceList() {
    return DatabaseHandler.instance.getSourcesList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<PothiSahibData>> fetchPothiSahibList() {
    return DatabaseHandler.instance.getPothiSahibList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<BanisModel>> fetchBanisList() {
    return DatabaseHandler.instance.getBanisList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<BanisModel>> fetchSearchBanisList(inputValue) {
    return DatabaseHandler.instance.getSearchBanisList(DatabaseHandler.databasePath,inputValue);
  }

  @override
  Future<List<GutkasModel>> fetchGutkasList() {
    return DatabaseHandler.instance.getGutkasList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<FavoriteDataItem>> fetchFavoriteList( int? folderId) {
    return DatabaseHandler.instance.getFavoriteList(folderId);
  }

  @override
  Future<Iterable<AppInfoData>> fetchAppInfo(int? sectionId, int? index) {
    return DatabaseHandler.instance.getAppInfoData(DatabaseHandler.databasePath,sectionId,index);
  }

  @override
  Future<List<ShabadDataItem>> fetchShabadList() {
    return DatabaseHandler.instance.fetchShabadList(DatabaseHandler.databasePath);
  }

  @override
  Future<List<WritersModel>>getWriterName(int writerId) {
    return DatabaseHandler.instance.getWritersName(DatabaseHandler.databasePath,writerId);
  }

  @override
  Future<List<FolderModel>>getFolderList() {
    return DatabaseHandler.instance.getAllFolderList();
  }

  @override
  Future<int>createFolder(FolderModel model) {
    return DatabaseHandler.instance.insertFolder(model);
  }

  @override
  Future<List<NoteDataItem>>getNotesList(int? folderId) {
    return DatabaseHandler.instance.getNotesList(folderId);
  }

  @override
  Future<int>addToNotes(NoteDataItem model) {
    return DatabaseHandler.instance.insertNote(model);
  }

  @override
  Future<int>reminderSubmission(RemindersData model) {
    return DatabaseHandler.instance.saveReminders(model);
  }

  @override
  Future<int>updateReminderStatus(RemindersData model) {
    return DatabaseHandler.instance.updateRecord(Strings.reminders,model);
  }

  @override
  Future<int>addToFavoriteList(FavoriteDataItem model) {
    return DatabaseHandler.instance.addToFavoriteList(model);
  }

  @override
  Future<int>deleteRecord(int Id, String tableName) {
    return DatabaseHandler.instance.deleteRecord(tableName, Id);
  }

  @override
  Future<int>trackerSubmission(TrackersData model) {
    return DatabaseHandler.instance.saveTracker(model);
  }

  @override
  Future<List<RemindersData>>getReminderList() {
    return DatabaseHandler.instance.getReminderList();
  }

  @override
  Future<int>deleteFolderRecord(int Id, String tableName) {
    return DatabaseHandler.instance.deleteFolderRecord(tableName, Id);
  }
  @override
  Future<List<GutkasModel>?> getGutkasSubBaniList(int? guktaId) {
    return DatabaseHandler.instance.getGutkasSubBaniList(DatabaseHandler.databasePath,guktaId);
  }

}