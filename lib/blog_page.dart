import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'blog_form.dart';
import 'services/supabase_service.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() {
    print('🏗️ createState() - Creating the State object');
    return _BlogPageState();
  }
}

class _BlogPageState extends State<BlogPage> {
  List<Map<String, dynamic>> blogs = [];
  bool isLoading = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    print(
      '🚀 initState() - Initializing state, setting up controllers, fetching initial data',
    );

    // Initialize search controller
    _searchController = TextEditingController();

    // Fetch blogs when the widget is first created
    _fetchBlogs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(
      '🔄 didChangeDependencies() - Dependencies have changed (InheritedWidget, Theme, etc.)',
    );

    // This is called after initState() and when dependencies change
    // Good place to access context-dependent data
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 build() - Building the UI widget tree');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/lifecycle');
            },
            icon: const Icon(Icons.science),
            tooltip: 'Test Lifecycle Methods',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search blogs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // Filter blogs based on search
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchBlogs,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _filteredBlogs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No blogs found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first blog',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _filteredBlogs.length,
                itemBuilder: (context, index) {
                  final blog = _filteredBlogs[index];
                  return BlogCard(
                    blog: blog,
                    onEdit: () => _editBlog(blog),
                    onDelete: () => _deleteBlog(blog['id']),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBlog,
        child: const Icon(Icons.add),
        tooltip: 'Add Blog',
      ),
    );
  }

  @override
  void didUpdateWidget(BlogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔧 didUpdateWidget() - Widget configuration has changed');

    // Called when the widget configuration changes
    // Compare oldWidget with current widget if needed
  }

  @override
  void deactivate() {
    super.deactivate();
    print('⏸️ deactivate() - Widget is being removed from the widget tree');

    // Called when the widget is removed from the widget tree
    // Can be reinserted later
  }

  @override
  void dispose() {
    print(
      '🗑️ dispose() - Cleaning up resources, widget is permanently removed',
    );

    // Clean up controllers and listeners
    _searchController.dispose();

    super.dispose();
  }

  // Get filtered blogs based on search query
  List<Map<String, dynamic>> get _filteredBlogs {
    if (_searchController.text.isEmpty) {
      return blogs;
    }
    return blogs.where((blog) {
      final title = blog['title']?.toString().toLowerCase() ?? '';
      final content = blog['content']?.toString().toLowerCase() ?? '';
      final query = _searchController.text.toLowerCase();
      return title.contains(query) || content.contains(query);
    }).toList();
  }

  // Fetch all blogs from Supabase
  Future<void> _fetchBlogs() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await SupabaseService.client
          .from('blogs')
          .select('*')
          .order('created_at', ascending: false);

      setState(() {
        blogs = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });

      print('✅ Fetched ${blogs.length} blogs');
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching blogs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error fetching blogs: $e');
    }
  }

  // Add new blog
  void _addBlog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BlogForm()),
    );

    if (result == true) {
      _fetchBlogs(); // Refresh the list
    }
  }

  // Edit existing blog
  void _editBlog(Map<String, dynamic> blog) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogForm(blog: blog)),
    );

    if (result == true) {
      _fetchBlogs(); // Refresh the list
    }
  }

  // Delete blog
  void _deleteBlog(String blogId) async {
    try {
      // Show confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Blog'),
          content: const Text('Are you sure you want to delete this blog?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await SupabaseService.client.from('blogs').delete().eq('id', blogId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blog deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        _fetchBlogs(); // Refresh the list
        print('✅ Blog deleted successfully');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting blog: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error deleting blog: $e');
    }
  }
}

// Blog Card Widget
class BlogCard extends StatelessWidget {
  final Map<String, dynamic> blog;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BlogCard({
    super.key,
    required this.blog,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog image
            if (blog['image_url'] != null &&
                blog['image_url'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: blog['image_url'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Blog title
            Text(
              blog['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Blog content
            Text(
              blog['content'] ?? 'No Content',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Blog metadata and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${_formatDate(blog['created_at'])}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
