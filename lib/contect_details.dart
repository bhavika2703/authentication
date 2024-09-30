import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/contect_bloc/contact_bloc.dart';
import 'package:untitled1/update_contect.dart';

class ContactDetails extends StatefulWidget {
  final String id;
  final String token;

  const ContactDetails({super.key, required this.id, required this.token});

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  @override
  void initState() {
    super.initState();
    context
        .read<ContactBloc>()
        .add(LoadContactDetails(id: widget.id, token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ContactBloc>()
        .add(LoadContactDetails(id: widget.id, token: widget.token));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactDetailsLoaded) {
            final contactDetails = state.contactDetails['data'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'ID',
                      style: buildTextStyle(),
                    ),
                    subtitle: Text(contactDetails['id'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('First Name',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['first_name'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Last Name',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['last_name'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Mobile',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['mobile'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Email',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['email'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Company Name',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['company_name'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Branch Name',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['branch_name'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Department Name',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['department_name'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Created At',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['created_at'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Updated At',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['updated_at'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Status',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['status'].toString() ?? ''),
                  ),
                  ListTile(
                    title:  Text('OTP',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['otp'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('OTP Expiry',style: buildTextStyle(),),
                    subtitle: Text(contactDetails['otp_expiry'] ?? ''),
                  ),
                  ListTile(
                    title:  Text('Is Change Password',style: buildTextStyle(),),
                    subtitle: Text(
                        contactDetails['is_change_password'].toString() ?? ''),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: contactDetails['contact_types'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Contact Type ${index + 1}', style: buildTextStyle(),),
                        subtitle: Text(contactDetails['contact_types'][index]['name'] ?? ''),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateContactScreen(
                                    id: widget.id,
                                    token: widget.token,
                                  )),
                        ).then((_) {
                          context.read<ContactBloc>().add(
                              LoadContacts(pageNumber: 1, token: widget.token));
                        });
                      },
                      child: const Text('Update Contact'),
                    ),
                  )
                ],
              ),
            );
          } else if (state is ContactDetailsLoadFailed) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  TextStyle buildTextStyle() => TextStyle(fontWeight: FontWeight.bold);
}
