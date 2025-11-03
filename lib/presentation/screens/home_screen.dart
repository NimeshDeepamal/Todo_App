import 'package:flutter/material.dart';
import 'package:todo_app/presentation/widgets/task_list.dart';
import 'package:todo_app/presentation/widgets/home_topnav.dart';
import 'package:todo_app/presentation/screens/add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopNavbar(),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Overview of your activities",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TaskListComponent(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditTaskScreen()));
        },
        backgroundColor: const Color.fromARGB(255, 7, 106, 255),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
