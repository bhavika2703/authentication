import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/contect_bloc/contact_bloc.dart';
import 'package:untitled1/bloc/repo.dart';
import 'package:untitled1/contect_details.dart';

class ContactList extends StatefulWidget {
  final String token;

  const ContactList({super.key, required this.token});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _scrollController = ScrollController();
  final _repo = Repo();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (context.read<ContactBloc>().state is ContactInitial) {
      context
          .read<ContactBloc>()
          .add(LoadContacts(pageNumber: 1, token: widget.token));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      final currentState = context.read<ContactBloc>().state;
      if (currentState is ContactLoaded) {
        if (currentState.contacts.length >= 10) {
          context.read<ContactBloc>().add(LoadContacts(
              pageNumber: currentState.pageNumber + 1, token: widget.token));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactLoaded) {
            setState(() {});
          }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.contacts[index];
                        return ListTile(
                          title: Text(contact['first_name'] ??
                              '' + ' ' + (contact['last_name'] ?? '')),
                          subtitle: Text(contact['mobile'] ?? ''),
                          onTap: () {
                            context.read<ContactBloc>().add(LoadContactDetails(
                                token: widget.token, id: contact['id']));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactDetails(
                                    id: contact['id'],
                                    token: widget.token,
                                  )),
                            ).then((_) {
                              context.read<ContactBloc>().add(LoadContacts(
                                  pageNumber: 1, token: widget.token));
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ContactBloc>().add(LoadContacts(
                          pageNumber: state.pageNumber + 1, token: widget.token));
                    },
                    child: const Text('Load More'),
                  ),
                ],
              );
            } else if (state is ContactLoadFailed) {
              return Center(
                child: Text(state.errorMsg),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildError(String errorMsg) {
    return Center(
      child: Text(
        errorMsg,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
