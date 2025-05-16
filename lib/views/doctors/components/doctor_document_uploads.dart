import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DoctorDocumentUploads extends StatefulWidget {
  final String doctorId;
  const DoctorDocumentUploads({super.key, required this.doctorId});

  @override
  State<DoctorDocumentUploads> createState() => _DoctorDocumentUploadsState();
}

class _DoctorDocumentUploadsState extends State<DoctorDocumentUploads> {
  bool _uploading = false;
  String? _uploadError;
  List<File> _localDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLocalDocs();
  }

  Future<Directory> _getDoctorDocDir() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final doctorDir = Directory('${baseDir.path}/doctor_docs/${widget.doctorId}');
    if (!await doctorDir.exists()) {
      await doctorDir.create(recursive: true);
    }
    return doctorDir;
  }

  Future<void> _loadLocalDocs() async {
    final dir = await _getDoctorDocDir();
    final files = dir.listSync().whereType<File>().toList();
    setState(() {
      _localDocs = files;
    });
  }

  Future<void> _pickAndSaveLocally(ImageSource source) async {
    setState(() {
      _uploadError = null;
      _uploading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) {
      setState(() { _uploading = false; });
      return;
    }
    try {
      final dir = await _getDoctorDocDir();
      final fileName = 'doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(pickedFile.path).copy('${dir.path}/$fileName');
      await _loadLocalDocs();
    } catch (e) {
      setState(() {
        _uploadError = 'Save failed: $e';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              onPressed:
                  _uploading ? null : () => _pickAndSaveLocally(ImageSource.camera),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              onPressed:
                  _uploading ? null : () => _pickAndSaveLocally(ImageSource.gallery),
            ),
          ],
        ),
        if (_uploading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          ),
        if (_uploadError != null)
          Text(_uploadError!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 16),
        const Text('Uploaded Documents:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_localDocs.isEmpty)
          const Text('No documents uploaded yet.')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _localDocs.length,
            itemBuilder: (context, idx) {
              final file = _localDocs[idx];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: () => _showFullImageDialog(context, file),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file, height: 120, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showFullImageDialog(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Image.file(
              file,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
