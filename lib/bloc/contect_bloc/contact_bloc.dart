import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:untitled1/bloc/repo.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final Repo _repo;

  ContactBloc({required Repo repo})
      : _repo = repo,
        super(ContactInitialState()) {
    on<LoadContacts>(_loadContacts);
    on<LoadContactDetails>(_loadContactDetails);
    on<UpdateContact>(_updateContact);
  }

  void _loadContacts(LoadContacts event, Emitter<ContactState> emit) async {
    emit(ContactFetchEventLoading());
    try {
      final response = await _repo.getContacts(
          pageNumber: event.pageNumber, token: event.token);
      var map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status']) {
          final contacts = jsonData['data'];
          emit(ContactFetchEventLoadedState(
              contacts: contacts, pageNumber: event.pageNumber));
        } else {
          emit(ContactFetchEventErrorState(
              errorMsg: map['message'] ?? 'Failed to load contacts',
              statusCode: response.statusCode));
        }
      } else {
        emit(ContactFetchEventErrorState(
            errorMsg: map['message'] ?? 'Failed to load contacts',
            statusCode: response.statusCode));
      }
    } catch (e) {
      emit(ContactFetchEventErrorState(errorMsg:  'Failed to load contacts',));
    }
  }

  void _loadContactDetails(
      LoadContactDetails event, Emitter<ContactState> emit) async {
    emit(ContactDetailsLoading());
    try {
      final response =
          await _repo.getContactDetails(id: event.id, token: event.token);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('jsonData:: $jsonData');
        emit(ContactDetailsLoaded(contactDetails: jsonData));
      } else {
        emit(ContactDetailsLoadFailed(
            errorMsg: 'Failed to load contact details'));
      }
    } catch (e) {
      emit(
          ContactDetailsLoadFailed(errorMsg: 'Failed to load contact details'));
    }
  }


  void _updateContact(UpdateContact event, Emitter<ContactState> emit) async {
    emit(ContactUpdateLoading());
    try {
      final response = await _repo.updateContact(contact: event.contact, token: event.token);
      final jsonData = jsonDecode(response.body);
      print('response:: ${response.statusCode}');
      print('update contact :: $jsonData');
      emit(ContactUpdateSuccessState());
    } catch (e) {
      emit(ContactUpdateErrorState(error: e.toString()));
    }
  }

}
