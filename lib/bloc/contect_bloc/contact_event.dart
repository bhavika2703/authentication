part of 'contact_bloc.dart';



abstract class ContactEvent {
  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactEvent {
  final int pageNumber;
  final String token;

  LoadContacts({required this.pageNumber, required this.token});

  @override
  List<Object?> get props => [pageNumber, token];
}

class LoadContactDetails extends ContactEvent {
  final String id;
  final String token;

   LoadContactDetails({required this.token,required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateContact extends ContactEvent {
  final Map<String, dynamic> contact;
  final String token;

   UpdateContact( {required this.contact,required this.token,});

  @override
  List<Object> get props => [contact,token];
}
