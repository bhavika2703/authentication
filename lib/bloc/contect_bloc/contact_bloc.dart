import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:untitled1/bloc/repo.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final Repo _repo;

  ContactBloc({required Repo repo})
      : _repo = repo,
        super(ContactInitial()) {
    on<LoadContacts>(_loadContacts);
    on<LoadContactDetails>(_loadContactDetails);
  }

  void _loadContacts(LoadContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final response = await _repo.getContacts(
          pageNumber: event.pageNumber, token: event.token);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status']) {
          final contacts = jsonData['data'];
          emit(ContactLoaded(contacts: contacts, pageNumber: event.pageNumber));
        } else {
          emit(ContactLoadFailed(errorMsg: 'Failed to load contacts'));
        }
      } else {
        emit(ContactLoadFailed(errorMsg: 'Failed to load contacts'));
      }
    } catch (e) {
      emit(ContactLoadFailed(errorMsg: 'Failed to load contacts'));
    }
  }


  void _loadContactDetails(LoadContactDetails event, Emitter<ContactState> emit) async {
    emit(ContactDetailsLoading());
    try {
      final response = await _repo.getContactDetails(id: event.id,token: event.token);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('jsonData:: $jsonData');
        emit(ContactDetailsLoaded(contactDetails: jsonData));
      } else {
        emit(ContactDetailsLoadFailed(errorMsg: 'Failed to load contact details'));
      }
    } catch (e) {
      emit(ContactDetailsLoadFailed(errorMsg: 'Failed to load contact details'));
    }
  }
}
