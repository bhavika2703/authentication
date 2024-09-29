part of 'contact_bloc.dart';




abstract class ContactState {
  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<dynamic> contacts;
  final int pageNumber;

  ContactLoaded({required this.contacts, required this.pageNumber});

  @override
  List<Object?> get props => [contacts, pageNumber];
}

class ContactLoadFailed extends ContactState {
  final String errorMsg;

  ContactLoadFailed({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
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