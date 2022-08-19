import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import '../../models/folder_model.dart';
import '../../services/repository.dart';
import '../../strings.dart';
import 'folder_event.dart';
import 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final Repository _repository;
  FolderBloc(this._repository) : super(FolderInitial()) {
    on<FolderEvent>((event, emit) async {
      try {
        List<FolderModel> data = await _repository.getFolderList();
        if(data.isNotEmpty) {
          emit(FolderLoaded(data: data));
        }else{
          List<FolderModel> data=[FolderModel(name: Strings.selectFolder,id: 0, date: currentDate())];
          emit(FolderLoaded(data: data));
        }
      } on Exception {
        emit(Error(message: Strings.unable_to_fetch_data));
      }
    });
  }
}
