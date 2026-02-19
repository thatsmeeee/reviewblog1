# Flutter Blog App with Supabase and Lifecycle Methods

A complete Flutter application that demonstrates proper use of StatefulWidget lifecycle methods while providing full CRUD functionality for a blog system powered by Supabase.

## Features

### 🔄 Lifecycle Methods Demonstration
The app includes a dedicated lifecycle test page (`test_life_cycle.dart`) that demonstrates all StatefulWidget lifecycle methods:

1. **createState()** - Creates the State object
2. **initState()** - Initializes state and controllers
3. **didChangeDependencies()** - Handles dependency changes
4. **build()** - Builds the UI widget tree
5. **didUpdateWidget()** - Handles widget configuration changes
6. **setState()** - Triggers UI rebuilds
7. **deactivate()** - Temporary widget removal
8. **dispose()** - Permanent cleanup

### 📝 Blog CRUD Operations
- **Create** new blog posts with title, content, and images
- **Read** and display blogs in a searchable list
- **Update** existing blog posts
- **Delete** blog posts with confirmation

### 🖼️ Image Management
- Upload images to Supabase Storage
- Display images using cached network images
- Support for camera and gallery image selection
- Automatic image optimization

### 🎨 Modern UI
- Material Design 3
- Clean and intuitive interface
- Responsive design
- Smooth animations and transitions

## Project Structure

```
lib/
├── main.dart              # App entry point with Supabase initialization
├── blog_page.dart          # Main blog list with lifecycle methods
├── blog_form.dart          # Add/edit blog form with lifecycle methods
├── test_life_cycle.dart    # Dedicated lifecycle demonstration page
└── services/
    └── supabase_service.dart # Supabase client management
```

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.11.0)
- Supabase account and project

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Supabase Setup

1. **Create a Supabase Project**
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note your project URL and anon key

2. **Set up Database**
   - Open the SQL Editor in your Supabase project
   - Run the SQL commands from `supabase_setup.sql`
   - This creates the `blogs` table and necessary policies

3. **Create Storage Bucket**
   - Go to Storage section in Supabase Dashboard
   - Create a new bucket named `blog-images`
   - Make it public
   - Set up policies for uploads and reads (see SQL file comments)

4. **Configure App**
   - Update `lib/services/supabase_service.dart` with your Supabase credentials:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

### 4. Run the App
```bash
flutter run
```

## Usage

### Blog Management
1. **View Blogs**: Main page shows all blog posts
2. **Add Blog**: Tap the + button to create a new blog
3. **Edit Blog**: Tap the edit icon on any blog post
4. **Delete Blog**: Tap the delete icon with confirmation
5. **Search**: Use the search bar to filter blogs

### Lifecycle Testing
1. Tap the science icon (🧪) in the app bar
2. Navigate through different sections
3. Watch the console output for lifecycle method calls
4. Test various scenarios:
   - Counter increments (setState)
   - Text input changes (controller listeners)
   - Widget rebuilds
   - Navigation between pages

## Lifecycle Method Explanations

### createState()
- **When called**: When Flutter builds the StatefulWidget
- **Purpose**: Creates the mutable State object
- **Usage**: Called exactly once per widget instance

### initState()
- **When called**: After the State object is created
- **Purpose**: Initialize controllers, subscriptions, and fetch initial data
- **Usage**: One-time setup that doesn't depend on context

### didChangeDependencies()
- **When called**: After initState() and when dependencies change
- **Purpose**: Handle context-dependent initializations
- **Usage**: Access InheritedWidget, Theme, MediaQuery

### build()
- **When called**: When UI needs to be rebuilt
- **Purpose**: Describe the widget tree
- **Usage**: Should be pure, fast, and have no side effects

### didUpdateWidget()
- **When called**: When parent widget rebuilds with new configuration
- **Purpose**: Respond to widget property changes
- **Usage**: Update animations or subscriptions

### setState()
- **When called**: When internal state changes
- **Purpose**: Schedule a UI rebuild
- **Usage**: Only call when UI needs to update

### deactivate()
- **When called**: When widget is temporarily removed
- **Purpose**: Clean up expensive resources
- **Usage**: Widget might be reinserted later

### dispose()
- **When called**: When widget is permanently removed
- **Purpose**: Final cleanup of controllers and listeners
- **Usage**: Always dispose controllers here

## Key Dependencies

- `supabase_flutter`: Supabase integration
- `image_picker`: Camera and gallery image selection
- `cached_network_image`: Efficient image loading and caching
- `uuid`: Generate unique IDs
- `go_router`: Navigation and routing

## Best Practices Demonstrated

1. **Resource Management**: Proper disposal of controllers and listeners
2. **State Management**: Correct use of setState for UI updates
3. **Error Handling**: Comprehensive error handling with user feedback
4. **Performance**: Efficient image caching and lazy loading
5. **User Experience**: Loading states, confirmations, and smooth transitions

## Troubleshooting

### Common Issues

1. **Supabase Connection Error**
   - Verify URL and anon key are correct
   - Check network connectivity
   - Ensure RLS policies are properly configured

2. **Image Upload Fails**
   - Verify storage bucket exists and is public
   - Check storage policies allow uploads
   - Ensure image size is within limits

3. **Lifecycle Methods Not Called**
   - Check console output for debugging
   - Verify widget is properly mounted
   - Ensure correct widget hierarchy

### Debug Tips

- Enable debug logging in Supabase initialization
- Use Flutter Inspector to examine widget tree
- Monitor network requests in DevTools
- Check console for lifecycle method logs

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is for educational purposes to demonstrate Flutter lifecycle methods and Supabase integration.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Lifecycle Methods](https://docs.flutter.dev/development/ui/interactive#stateful-and-stateless-widgets)
- [Supabase Flutter Integration](https://supabase.com/docs/guides/getting-started/flutter)
