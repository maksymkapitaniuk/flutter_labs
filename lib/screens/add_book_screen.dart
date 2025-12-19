import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_strings.dart';
import '../core/providers/reading_provider.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();

  String _status = AppStrings.inProgressStatus;

  XFile? _selectedImage;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        await context.read<ReadingProvider>().addBook(
          title: _titleController.text,
          author: _authorController.text,
          genre: _genreController.text,
          totalPages: int.parse(_pagesController.text),
          status: _status,
          coverImage: _selectedImage,
        );

        if (mounted) {
          setState(() => _isSaving = false);
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.saveError}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addBook)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? _buildImagePreview()
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.grey),
                            Text(
                              AppStrings.coverLabel,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: AppStrings.bookTitleLabel,
                controller: _titleController,
              ),
              CustomTextField(
                label: AppStrings.author,
                controller: _authorController,
              ),
              CustomTextField(
                label: AppStrings.genre,
                controller: _genreController,
              ),
              CustomTextField(
                label: AppStrings.pagesCountLabel,
                controller: _pagesController,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items:
                    [
                          AppStrings.plannedStatus,
                          AppStrings.inProgressStatus,
                          AppStrings.completedStatus,
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => _status = v!),
                decoration: const InputDecoration(
                  labelText: AppStrings.statusLabel,
                ),
              ),
              const SizedBox(height: 24),
              _isSaving
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: AppStrings.saveBookButton,
                      onPressed: _saveBook,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) return const SizedBox();

    if (kIsWeb) {
      return Image.network(_selectedImage!.path, fit: BoxFit.cover);
    } else {
      return Image.file(File(_selectedImage!.path), fit: BoxFit.cover);
    }
  }
}
