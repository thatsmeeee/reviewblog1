import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'services/supabase_service.dart';

class BlogForm extends StatefulWidget {
  final Map<String, dynamic>? blog;

  const BlogForm({super.key, this.blog});

  @override
  State<BlogForm> createState() => _BlogFormState();
}

class _BlogFormState extends State<BlogForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String? _imageUrl;
  String? _imagePath;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    print(
      '🚀 BlogForm initState() - Initializing state, setting up controllers',
    );

    // If editing existing blog, populate the form
    if (widget.blog != null) {
      _titleController.text = widget.blog!['title'] ?? '';
      _contentController.text = widget.blog!['content'] ?? '';
      _imageUrl = widget.blog!['image_url'];
      print('📝 Editing existing blog: ${widget.blog!['title']}');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 BlogForm didChangeDependencies() - Dependencies have changed');
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 BlogForm build() - Building the UI widget tree');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog == null ? 'Add Blog' : 'Edit Blog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.blog != null)
            IconButton(
              onPressed: _deleteImage,
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Remove Image',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image section
                _buildImageSection(),

                const SizedBox(height: 20),

                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Content field
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.article),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading || _isUploading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading || _isUploading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Uploading...'),
                          ],
                        )
                      : Text(
                          widget.blog == null ? 'Create Blog' : 'Update Blog',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(BlogForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔧 BlogForm didUpdateWidget() - Widget configuration has changed');
  }

  @override
  void deactivate() {
    super.deactivate();
    print(
      '⏸️ BlogForm deactivate() - Widget is being removed from the widget tree',
    );
  }

  @override
  void dispose() {
    print('🗑️ BlogForm dispose() - Cleaning up resources');

    // Clean up controllers
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Blog Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Image display/upload area
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _imagePath != null
              ? Image.network(
                  _imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                )
              : _imageUrl != null && _imageUrl!.isNotEmpty
              ? Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                )
              : _buildImagePlaceholder(),
        ),

        const SizedBox(height: 8),

        // Image buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _pickImageFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _pickImageFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
          ],
        ),

        if (_isUploading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image, size: 64, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          'No image selected',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Future<void> _pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });

        // Upload image to Supabase Storage
        await _uploadImage(image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error picking image: $e');
    }
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      setState(() {
        _isUploading = true;
      });

      final String fileName = '${const Uuid().v4()}.jpg';
      final String filePath = 'blog-images/$fileName';

      // Upload to Supabase Storage
      await SupabaseService.client.storage
          .from('blog-images')
          .upload(filePath, File(image.path));

      // Get public URL
      final String publicUrl = SupabaseService.client.storage
          .from('blog-images')
          .getPublicUrl(filePath);

      setState(() {
        _imageUrl = publicUrl;
        _isUploading = false;
      });

      print('✅ Image uploaded successfully: $publicUrl');
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error uploading image: $e');
    }
  }

  Future<void> _deleteImage() async {
    if (_imageUrl == null || _imageUrl!.isEmpty) return;

    try {
      // Extract file path from URL
      final Uri uri = Uri.parse(_imageUrl!);
      final String? filePath = uri.pathSegments.lastWhere(
        (segment) => segment.contains('.'),
        orElse: () => '',
      );

      if (filePath != null && filePath.isNotEmpty) {
        await SupabaseService.client.storage.from('blog-images').remove([
          'blog-images/$filePath',
        ]);
      }

      setState(() {
        _imageUrl = null;
        _imagePath = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      print('✅ Image deleted successfully');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error deleting image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final blogData = {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'image_url': _imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (widget.blog == null) {
        // Create new blog
        blogData['id'] = const Uuid().v4();
        blogData['created_at'] = DateTime.now().toIso8601String();

        await SupabaseService.client.from('blogs').insert(blogData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blog created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        print('✅ Blog created successfully');
      } else {
        // Update existing blog
        await SupabaseService.client
            .from('blogs')
            .update(blogData)
            .eq('id', widget.blog!['id']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blog updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        print('✅ Blog updated successfully');
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving blog: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error saving blog: $e');
    }
  }
}
