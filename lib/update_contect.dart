import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/contect_bloc/contact_bloc.dart';
import 'package:untitled1/login_screen.dart';


class UpdateContactScreen extends StatefulWidget {
  final String id;
  final String token;

  const UpdateContactScreen({super.key, required this.id, required this.token});

  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _contactTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(
        LoadContactDetails(id: widget.id, token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: const Text('Update Contact'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
            if (state is ContactUpdateErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
              if (state.error.contains('TokenExpire')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            }
            if (state is ContactUpdateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact updated successfully'),
                ),
              );
              Navigator.pop(context);
              context.read<ContactBloc>().add(LoadContacts(pageNumber: 1, token: widget.token));
            }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactDetailsLoaded) {
              final contactDetails = state.contactDetails['data'];
              if (contactDetails != null && contactDetails.isNotEmpty) {
                _firstNameController.text = contactDetails['first_name'] ?? '';
                _lastNameController.text = contactDetails['last_name'] ?? '';
                _mobileController.text = contactDetails['mobile'] ?? '';
                //_contactTypeController.text = contactDetails['contact_types'][0]['name'] ?? '';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileController,
                          decoration: const InputDecoration(
                            labelText: 'Mobile',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        /*TextFormField(
                        controller: _contactTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Type',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact type';
                          }
                          return null;
                        },
                      ),*/
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() && _mobileController.text.isNotEmpty) {
                              final contact = {
                                'id': widget.id,
                                'first_name': _firstNameController.text,
                                'last_name': _lastNameController.text,
                                'mobile': _mobileController.text,
                                'contact_types': [
                                  {
                                    'contact_type_id': 'a1dd708a-3db5-11ef-9634-484520bf7692',
                                    'name': _contactTypeController.text,
                                  }
                                ]
                              };

                              context.read<ContactBloc>().add(UpdateContact(
                                contact: contact,
                                token: widget.token,
                              ));
                            }else{
                              const SnackBar(content: Text('Please enter proper data'),);
                            }
                          },
                          child: const Text('Update Contact'),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: Text('No contact details available'));
              }
            } else if (state is ContactDetailsLoadFailed) {
              return Center(child: Text(state.errorMsg));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}