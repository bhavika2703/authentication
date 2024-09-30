part of 'contact_bloc.dart';

abstract class ContactState {
  @override
  List<Object?> get props => [];
}

//fetch

class ContactInitialState extends ContactState {}

class ContactFetchEventLoading extends ContactState {}

class ContactFetchEventLoadedState extends ContactState {
  final List<dynamic> contacts;
  final int pageNumber;

  ContactFetchEventLoadedState(
      {required this.contacts, required this.pageNumber});

  @override
  List<Object?> get props => [contacts, pageNumber];
}

class ContactFetchEventErrorState extends ContactState {
  final String? errorMsg;
  final int? statusCode;

  ContactFetchEventErrorState(
      { this.errorMsg,  this.statusCode});


}

class ContactDetailsLoaded extends ContactState {
  final Map<String, dynamic> contactDetails;

  ContactDetailsLoaded({required this.contactDetails});

  @override
  List<Object> get props => [contactDetails];
}

class ContactDetailsLoading extends ContactState {}

class ContactDetailsLoadFailed extends ContactState {
  final String errorMsg;

  ContactDetailsLoadFailed({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

/*class ContactUpdated extends ContactState {
  final Map<String, dynamic> contact;

   ContactUpdated({required this.contact});

  @override
  List<Object> get props => [contact];
}

class ContactUpdateLoading extends ContactState {}

class ContactUpdateFailed extends ContactState {
  final String errorMsg;

   ContactUpdateFailed({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}*/

//update
class ContactUpdateInitialState extends ContactState {}

class ContactUpdateLoading extends ContactState {}

class ContactUpdateSuccessState extends ContactState {}

class ContactUpdateErrorState extends ContactState {
  final String error;
  final int? statusCode;

  ContactUpdateErrorState({required this.error, this.statusCode});

  @override
  List<Object> get props => [error];
}
