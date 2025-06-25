import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../services/file_service.dart';
import '../widgets/pdf_tile.dart';

class DownloadedReportsScreen extends StatefulWidget {
  @override
  State<DownloadedReportsScreen> createState() => _DownloadedReportsScreenState();
}

class _DownloadedReportsScreenState extends State<DownloadedReportsScreen> {
  List<FileSystemEntity> files = [];
  List<FileSystemEntity> selectedFiles = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final list = await FileService.listDownloadedFiles();
    setState(() {
      files = list;
      selectedFiles.clear();
    });
  }

  void _onFileTap(FileSystemEntity file) {
    OpenFile.open(file.path);
  }

  void _onLongPress(FileSystemEntity file) {
    setState(() {
      selectedFiles.contains(file)
          ? selectedFiles.remove(file)
          : selectedFiles.add(file);
    });
  }

  void _onDeleteSelected() async {
    final count = selectedFiles.length;
    await FileService.deleteFiles(selectedFiles);
    setState(() {
      selectedFiles.clear();
    });
    _loadFiles();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count file${count > 1 ? 's' : ''} deleted successfully.'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }


  bool isSelected(FileSystemEntity file) => selectedFiles.contains(file);

  @override
  @override
  Widget build(BuildContext context) {
    final filteredFiles = files.where((file) {
      final fileName = file.path.split('/').last.toLowerCase();
      return fileName.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Downloaded Reports",style: TextStyle(color: Colors.white),),
        actions: selectedFiles.isNotEmpty
            ? [
          IconButton(icon: Icon(Icons.delete,color: Colors.white,), onPressed: _onDeleteSelected)
        ]
            : [],
      ),
      body: files.isEmpty
          ? const Center(child: Text("No downloaded reports"))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search PDFs...',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (_, index) {
                final file = filteredFiles[index];
                return PdfTile(
                  file: file,
                  isSelected: isSelected(file),
                  onTap: () => _onFileTap(file),
                  onLongPress: () => _onLongPress(file),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: Icon(Icons.download,color: Colors.white,),
        label: Text("Download PDF",style: TextStyle(color: Colors.white),),
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Downloading..."),
                ],
              ),
            ),
          );
          final url = "https://sample-files.com/downloads/documents/pdf/basic-text.pdf";
          await FileService.downloadPdf(url, 'report_${DateTime.now().millisecondsSinceEpoch}.pdf');
          Navigator.pop(context);
          _loadFiles();
        },
      ),

    );
  }

}
