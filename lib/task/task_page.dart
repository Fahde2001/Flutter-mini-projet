import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testflutter/OnbodingScreen.dart';

import 'Task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TaskFlow',
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Poppins",
            height: 1.2,
          ),
        ),
        backgroundColor: Colors.white, // Set your preferred color
        leading: IconButton(
          icon: Icon(Icons.logout), // Change this to your desired logout icon
          onPressed: () {
            _showLogoutConfirmationDialog();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => _deleteTask(context, index),
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        ),
                        SlidableAction(
                          onPressed: (context) => _updateTask(context, index),
                          label: 'Update',
                          backgroundColor: Colors.lightGreen,
                          icon: Icons.update,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => _deleteTask(context, index),
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: CheckboxListTile(
                      title: Text(tasks[index].name),
                      value: tasks[index].completed,
                      onChanged: (value) {
                        setState(() {
                          tasks[index].completed = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, // Align checkbox to the left
                      contentPadding:
                          EdgeInsets.all(0), // Remove default padding
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 56.0, // Adjust the size as needed
        height: 56.0, // Adjust the size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black, // Set your preferred color
        ),
        child: InkWell(
          onTap: () {
            _showAddTaskDialog();
          },
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white, // Set your preferred icon color
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40.0,
        child: BottomAppBar(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: CircularNotchedRectangle(),
          color: Color.fromRGBO(0, 0, 0, 1.0),
          child: ClipPath(
            clipper: MyBottomAppBarClipper(),
            child: Container(
              height: 40.0,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newTask = '';

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    newTask = value;
                  },
                  decoration: InputDecoration(labelText: 'Task'),
                ),
                SizedBox(height: 11.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (newTask.isNotEmpty) {
                          setState(() {
                            tasks.add(Task(name: newTask));
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteTask(BuildContext context, int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _updateTask(BuildContext context, int index) {
    print('Update task: ${tasks[index].name}');
  }

  String accessToken = '';
  String refreshToken = '';
  Future<void> getTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken') ?? '';
      refreshToken = prefs.getString('refreshToken') ?? '';
    });
    print('\n\n\n\n\n $accessToken\n\n\n\n');
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: getTokens,
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OnbodingScreen(), // Replace YourHomePage with the actual home page widget
                  ),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyBottomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height + 10, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
