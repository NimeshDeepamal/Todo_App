import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleC;
  late TextEditingController _descC;
  DateTime? _dueDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.task?.title ?? '');
    _descC = TextEditingController(text: widget.task?.description ?? '');
    _dueDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    try {
      final now = DateTime.now();
      final initialDate = _dueDate ?? now;

      final date = await showDatePicker(
        context: context,
        initialDate: initialDate.isBefore(now) ? now : initialDate,
        firstDate: now,
        lastDate: DateTime(2100),
      );

      if (date == null || !mounted) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
      );

      if (time == null || !mounted) return;

      final selected = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      if (selected.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You cannot select a past date or time'),
          ),
        );
        return;
      }

      setState(() {
        _dueDate = selected;
      });
    } catch (e) {
      debugPrint("Error picking date/time: $e");
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Prevent double clicks
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final title = _titleC.text.trim();
    final desc = _descC.text.trim();
    final due = _dueDate!;
    final notifier = ref.read(taskListProvider.notifier);

    try {
      if (widget.task == null) {
        // Add — provider will update UI immediately (local-first)
        await notifier.addTask(title: title, description: desc, dueDate: due);
        if (!mounted) return;

        // show success quickly then pop
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Task added successfully!'),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(milliseconds: 700),
          ),
        );
      } else {
        // Update — provider updates UI immediately
        final updated = widget.task!.copyWith(
          title: title,
          description: desc,
          dueDate: due,
        );
        await notifier.updateTask(updated);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Task updated successfully!'),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(milliseconds: 700),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error saving task: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save task: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      // Always stop spinner while widget still mounted
      if (mounted) setState(() => _isSaving = false);

      // short delay so user sees snack, then pop returning "true" to signal success
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 241, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 10, 57, 175),
        elevation: 0,
        title: Text(
          isEdit ? "Edit Task" : "Add New Task",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Task Title",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleC,
                    decoration: InputDecoration(
                      hintText: "Enter task title...",
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descC,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write a short description...",
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _dueDate == null
                                ? "No date selected"
                                : "Due: ${_dueDate!.toLocal().toString().substring(0, 16)}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _pickDateTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(
                            255,
                            35,
                            121,
                            226,
                          ),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 7, 106, 255),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Pick Date",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 7, 106, 255),
                            Color.fromARGB(255, 117, 207, 252),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEdit ? "Save Changes" : "Add Task",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
