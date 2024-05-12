import 'package:flutter/material.dart';
import 'package:paw_rescue/src/widgets.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Page'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset('assets/codelab.jpg'),
              title: Text('Report Name'),
              subtitle: Text('Location'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open the form with three fields
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Report'),
                content: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Field 1'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Field 2'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Field 3'),
                    ),
                  ],
                ),
                actions: [
                  StyledButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  StyledButton(
                    child: Text('Add'),
                    onPressed: () {
                      // Perform the add operation
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
