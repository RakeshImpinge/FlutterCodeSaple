import 'dart:io';
import 'package:flutter/services.dart';
import 'package:learn_shudh_gurbani/models/create_reminders_data.dart';
import 'package:learn_shudh_gurbani/models/favorite_data_item.dart';
import 'package:learn_shudh_gurbani/models/note_data_item.dart';
import 'package:learn_shudh_gurbani/models/folder_model.dart';
import 'package:learn_shudh_gurbani/models/pothi_sahib_data.dart';
import 'package:learn_shudh_gurbani/models/shabad.dart';
import 'package:learn_shudh_gurbani/models/trackers_data.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../models/app_info_data.dart';
import '../models/banis.dart';
import '../models/gutkas.dart';
import '../models/raag_data.dart';
import '../models/sources.dart';
import '../models/writers.dart';
import '../strings.dart';

class DatabaseHandler {
  static const _databaseName = "demo.db";
  static const _databaseVersion = 1;
  static var databasePath ="";
  static final table = 'folders';
  static final columnId = 'id';
  static final bani_id='bani_id';
  static final columnTitle = 'name';
  static const note_table='note';
  static final user_table='user_table';
  static final folder_id='folder_id';
  static final pangti_name='pangti_name';
  static final folder_name='folder_name';
  static final message='message';
  static final date='date';
  static final title='title';
  static final occurance='occurance';
  static final repeat='repeat';
  static final tracker_id='tracker_id';
  static final ringtone_id='ringtone_id';
  static final reminderStatus='reminderStatus';
  DatabaseHandler._privateConstructor();
  static final DatabaseHandler instance = DatabaseHandler._privateConstructor();
   static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $date text not null
          )
          ''');
  }

  /*
   * save folder name in database
   */
  Future<int> insertFolder(FolderModel createFolder) async {
    Database db = await instance.database;
    var response = await db.insert(table, createFolder.toJson());
    return response;
  }

/*
  method to add favorite list
 */
  Future<int> addToFavoriteList(FavoriteDataItem favoriteDataItem) async {
    Database db = await instance.database;
    var response = await db.insert(Strings.favorites, favoriteDataItem.toMap());
    return response;
  }

  /*
   * save folder name in database
   */
  Future<int> saveReminders(RemindersData model) async {
    Database db = await instance.database;
    var response = await db.insert(Strings.reminders, model.toJson());
    return response;
  }

  /*
   * save folder name in database
   */
  Future<int> saveTracker(TrackersData model) async {
    Database db = await instance.database;
    var response = await db.insert(Strings.tracker, model.toJson());
    return response;
  }

  /*
   save Note into database
   */
  Future<int> insertNote(NoteDataItem noteDataItem) async {
    Database db = await instance.database;
    var response = await db.insert(note_table, noteDataItem.toJson());
    return response;
  }

  /*
   *  get list of folder name
   */
  Future<List<FolderModel>> getAllFolderList() async {
    Database db = await instance.database;
    var response = await db.query(table, orderBy: "$columnId ASC");
    if (response.isNotEmpty) {
      return response.map((e) => FolderModel.fromJson(e)).toList();
   }
    else {
      throw Exception('Failed to load folder');
    }
  }

  /*
  Get list of noted
   */
  Future<List<NoteDataItem>> getNotesList([int? folderId]) async {
    Database db = await instance.database;
    var response =  folderId!=null? await db.rawQuery('SELECT * FROM ${note_table} where folder_id= $folderId'): await db.query(note_table, orderBy: "$columnId ASC",groupBy: "$folder_id");
    if (response.isNotEmpty) {
      return response.map((e) => NoteDataItem.fromJson(e)).toList();
    } else {
      throw Exception('Notes not added yet!!');
    }
  }

  /*
   get favorite list
   */
  Future<List<FavoriteDataItem>> getFavoriteList([int? folderId]) async {
    Database db =  await instance.database;
    var response =  folderId!=null? await db.rawQuery('SELECT * FROM ${Strings.favorites} where folder_id= $folderId'): await db.rawQuery('SELECT * FROM ${Strings.favorites} GROUP BY "$folder_id"');
    if (response.isNotEmpty) {
      return response.map((dynamic json) {
        return FavoriteDataItem.fromMap(json);
      }).toSet().toList();
    }else {
      throw Exception('Failed to load List');
    }
  }

  /*
   get reminder list
   */
  Future<List<RemindersData>>getReminderList() async {
    Database db = await instance.database;
    var response = await db.query(Strings.reminders, orderBy: "$columnId ASC");
    if (response.isNotEmpty) {
      return response.map((e) => RemindersData.fromJson(e)).toList();
    } else {
      throw Exception('No Reminder Created Yet!!');
    }
  }

  /*
  update record in table
   */
  Future<int> updateRecord(String table, dynamic model ) async {
    Database db = await database;
    var result = await db.update(table, model.toJson(), where: '${columnId} = ${model.id}');
    return result;
  }

  Future<int> deleteRecord(String table, int Id ) async {
    Database db = await database;
    var result = await db.rawDelete('DELETE FROM $table WHERE ${columnId} = $Id ');
    return result;
  }

  Future<int> deleteFolderRecord( String table, int Id ) async {
    Database db = await database;
    var result = await db.rawDelete('DELETE FROM $table WHERE ${folder_id} = $Id ');
    return result;
  }

/*
 unlock database
 */
  unlockDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test_data.db");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets/db', 'test_data.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await  File(path).writeAsBytes(bytes);
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
     databasePath = join(appDocDir.path, 'test_data.db');
   }

  /*
  Fetch writers List data
   */
  Future<List<WritersModel>> getWritersList(databasePath) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM writers');
    if (response.isNotEmpty) {
      return response.map((e) => WritersModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Writers');
    }
  }

  /*
  Fetch Source list data
   */
  Future<List<SourcesModel>>getSourcesList(databasePath) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM sources');
    if (response.isNotEmpty) {
      return response.map((e) => SourcesModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Source list');
    }
  }

  /*
   *  Get list of writer name
   */
  Future<List<WritersModel>>getWritersName(databasePath, int writerId) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM writers where id=$writerId');
    if (response.isNotEmpty) {
      return response.map((e) => WritersModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to writers');
    }
  }

  /*
  Fetch Pothi Sahib data
   */
  Future<List<PothiSahibData>>getPothiSahibList(databasePath) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM pothi_sources');
    if (response.isNotEmpty) {
      return response.map((e) => PothiSahibData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Pothi list');
    }
  }

  /*
  Fetch Raag List data
   */
  Future<List<RaagModel>> getRaagList(databasePath) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM sections where id between 5 and 35');
    if (response.isNotEmpty) {
      return response.map((e) => RaagModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Raag List');
    }
  }

  /*
  Fetch Gutkas List data
   */
  Future<List<GutkasModel>> getGutkasList(databasePath) async {
    List<GutkasModel> list;
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM gutkas');
   // var response = await db.rawQuery('SELECT * FROM banis where id in (3, 4,5,6,7,8,10,11,14,21,22,23,24,25,27,30,31,33,34,35,38,90,96,101,104,110)');
    if (response.isNotEmpty) {
      return response.map((dynamic json) {
        return GutkasModel.fromMap(json);
      }).toList();
    }else {
      throw Exception('Failed to load Gutkas List');
    }
  }

  /*
  Fetch Gutkas List data
   */
  Future<List<GutkasModel>?> getGutkasSubBaniList(databasePath,guktaId) async {
   List<GutkasModel> list;
    Database db = await openDatabase(databasePath, readOnly: true);


   var response = await db.rawQuery('SELECT * FROM gutka_banis where gutka_id=$guktaId Order by gutka_id');

       return response.map((dynamic json) {
         return GutkasModel.fromMap(json);
       }).toList();


  }


  /*
  Fetch App Info data
   */
  Future<Iterable<AppInfoData>> getAppInfoData(databasePath,int? sectionId, int? subsectionId) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM app_info where section_id=$sectionId and subsection_id=$subsectionId');
    if (response.isNotEmpty) {
      return response.map((dynamic json) {
        return AppInfoData.fromMap(json);
      });
    }else {
      throw Exception('Failed to load App Info');
    }
  }

  /*
  Fetch Banis List data
   */
  Future<List<BanisModel>> getBanisList(databasePath) async {
    Database db = await openDatabase(DatabaseHandler.databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM banis');
    if (response.isNotEmpty) {
      return response.map((dynamic json) {
        return BanisModel.fromMap(json);
      }).toList();
    } else {
      throw Exception('Failed to load Banis List');
    }
  }

  /*
  Fetch Search Banis List data
   */
  Future<List<BanisModel>> getSearchBanisList(databasePath, inputValue) async {
    Database db = await openDatabase(DatabaseHandler.databasePath, readOnly: true);
   var response = await db.rawQuery("SELECT * FROM 'verses' where gurmukhi like '%$inputValue%'");
    if (response.isNotEmpty) {
      return response.map((dynamic json) {
        return BanisModel.fromMap(json);
      }).toList();
    } else {
      throw Exception('Failed to load Banis List');
    }
  }

  /*
  Fetch shabad data
   */
  Future<List<ShabadDataItem>> fetchShabadList(databasePath) async {
    Database db = await openDatabase(databasePath, readOnly: true);
    var response = await db.rawQuery('SELECT * FROM verses limit 0,20');
    if (response.isNotEmpty) {
      return response.map((dynamic json) {
        return ShabadDataItem.fromMap(json);
      }).toList();
    }else {
      throw Exception('Failed to load Random Shabad List');
    }
  }
 }