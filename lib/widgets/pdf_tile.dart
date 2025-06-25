import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfTile extends StatefulWidget {
  final FileSystemEntity file;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PdfTile({
    Key? key,
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<PdfTile> createState() => _PdfTileState();
}

class _PdfTileState extends State<PdfTile> {
  PdfPageImage? thumbnail;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final pdfDoc = await PdfDocument.openFile(widget.file.path);
    final page = await pdfDoc.getPage(1);
    final img = await page.render(width: 120, height: 160);
    await page.close();
    setState(() {
      thumbnail = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.file.path.split('/').last;
    final stat = File(widget.file.path).statSync();
    final fileSize = (stat.size / 1024).toStringAsFixed(1) + " KB";
    final modified = stat.modified.toLocal();

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Card(
        elevation: 5,
        color: widget.isSelected ? Colors.grey[200] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: widget.isSelected
              ? const BorderSide(color: Colors.blueAccent, width: 2)
              : BorderSide.none,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: thumbnail != null
                    ? Image.memory(thumbnail!.bytes, width: 60, height: 80, fit: BoxFit.cover)
                    : Container(
                  width: 60,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.picture_as_pdf, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text("Size: $fileSize", style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 2),
                    Text("Saved: ${modified.toString().split('.')[0]}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              widget.isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
