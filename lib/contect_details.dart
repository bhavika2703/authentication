import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/contect_bloc/contact_bloc.dart';

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
                    title: const Text('ID'),
                    subtitle: Text(contactDetails['id'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('First Name'),
                    subtitle: Text(contactDetails['first_name'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Last Name'),
                    subtitle: Text(contactDetails['last_name'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Mobile'),
                    subtitle: Text(contactDetails['mobile'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(contactDetails['email'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Company Name'),
                    subtitle: Text(contactDetails['company_name'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Branch Name'),
                    subtitle: Text(contactDetails['branch_name'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Department Name'),
                    subtitle: Text(contactDetails['department_name'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Created At'),
                    subtitle: Text(contactDetails['created_at'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Updated At'),
                    subtitle: Text(contactDetails['updated_at'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Status'),
                    subtitle: Text(contactDetails['status'].toString() ?? ''),
                  ),
                  ListTile(
                    title: const Text('OTP'),
                    subtitle: Text(contactDetails['otp'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('OTP Expiry'),
                    subtitle: Text(contactDetails['otp_expiry'] ?? ''),
                  ),
                  ListTile(
                    title: const Text('Is Change Password'),
                    subtitle: Text(
                        contactDetails['is_change_password'].toString() ?? ''),
                  ),
                  ListTile(
                    title: const Text('Contact Type'),
                    subtitle:
                        Text(contactDetails['contact_types'][0]['name'] ?? ''),
                  ),
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
}
