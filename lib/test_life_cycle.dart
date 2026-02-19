import 'package:flutter/material.dart';

/// This file demonstrates all Flutter StatefulWidget lifecycle methods
/// with detailed logging and explanations of when each method is called.

class TestLifecyclePage extends StatefulWidget {
  const TestLifecyclePage({super.key});

  @override
  State<TestLifecyclePage> createState() {
    print('🏗️ createState() - Called when Flutter builds the StatefulWidget');
    print('   This method creates the mutable State object');
    print('   It is called exactly once for each StatefulWidget instance');
    return _TestLifecyclePageState();
  }
}

class _TestLifecyclePageState extends State<TestLifecyclePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Controllers and state variables
  late TextEditingController _textController;
  late AnimationController _animationController;
  int _counter = 0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    print('🚀 initState() - Called when the State object is first created');
    print('   This is the ideal place for:');
    print(
      '   - Initializing controllers (TextEditingController, AnimationController)',
    );
    print('   - Setting up subscriptions and listeners');
    print('   - Making initial API calls');
    print('   - Initializing data that doesn\'t depend on context');

    // Initialize controllers
    _textController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Add listener to observe changes
    _textController.addListener(() {
      print('📝 TextEditingController changed: ${_textController.text}');
    });

    // Add WidgetsBindingObserver to track app lifecycle
    WidgetsBinding.instance.addObserver(this);

    // Start animation
    _animationController.repeat(reverse: true);

    // Simulate initial data fetch
    _fetchInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(
      '🔄 didChangeDependencies() - Called when dependencies of this State object change',
    );
    print('   This method is called after initState() and when:');
    print('   - InheritedWidget dependencies change');
    print('   - Theme, MediaQuery, or Localizations change');
    print('   - The widget is rebuilt with new context');
    print('   - Good place for context-dependent initializations');

    // Example: Accessing Theme or MediaQuery
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    print('   Current theme primary color: ${theme.primaryColor}');
    print('   Screen size: ${mediaQuery.size}');
  }

  @override
  Widget build(BuildContext context) {
    print(
      '🎨 build() - Called to describe the part of the user interface represented by this widget',
    );
    print(
      '   This method can be called many times during the widget\'s lifetime',
    );
    print('   It should be pure (no side effects) and fast');
    print('   Current counter value: $_counter');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifecycle Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _rebuildWidget,
            icon: const Icon(Icons.refresh),
            tooltip: 'Rebuild Widget',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Counter section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Counter: $_counter',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _incrementCounter,
                          child: const Text('Increment'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _decrementCounter,
                          child: const Text('Decrement'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Text input section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Input Test:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type something to see listener logs',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Animation section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Animation Test:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(
                              _animationController.value,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${(_animationController.value * 100).toInt()}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lifecycle info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lifecycle Information:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Widget disposed: $_isDisposed'),
                    Text('Check console for detailed lifecycle logs'),
                    const SizedBox(height: 8),
                    const Text(
                      'Lifecycle Methods Called:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('• createState()'),
                    const Text('• initState()'),
                    const Text('• didChangeDependencies()'),
                    const Text('• build()'),
                    const Text('• didUpdateWidget() (when parent rebuilds)'),
                    const Text('• setState() (when state changes)'),
                    const Text('• deactivate() (when removed from tree)'),
                    const Text('• dispose() (when permanently removed)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _testSetState,
        child: const Icon(Icons.play_arrow),
        tooltip: 'Test setState()',
      ),
    );
  }

  @override
  void didUpdateWidget(TestLifecyclePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(
      '🔧 didUpdateWidget() - Called when the widget configuration changes',
    );
    print('   This happens when the parent widget rebuilds with new data');
    print('   Compare oldWidget with current widget to respond to changes');
    print('   Good place to update animations or subscriptions');

    // Example: Check if widget properties changed
    if (oldWidget.key != widget.key) {
      print('   Widget key changed');
    }
  }

  @override
  void setState(VoidCallback fn) {
    print(
      '⚡ setState() - Called to notify Flutter that the internal state has changed',
    );
    print('   This will schedule a call to build() to update the UI');
    print('   Only call setState() when you actually need to update the UI');

    super.setState(fn);
  }

  @override
  void deactivate() {
    super.deactivate();
    print(
      '⏸️ deactivate() - Called when the widget is removed from the widget tree',
    );
    print(
      '   The framework can reinsert this State object into another part of the tree',
    );
    print('   This is temporary removal, not permanent disposal');
    print(
      '   Clean up expensive resources here, but keep what might be reused',
    );
  }

  @override
  void dispose() {
    print(
      '🗑️ dispose() - Called when the State object and its StatefulWidget are permanently removed',
    );
    print('   This is the final cleanup opportunity');
    print('   Always dispose controllers, subscriptions, and listeners here');
    print('   After dispose(), the State object is no longer usable');

    // Mark as disposed for debugging
    _isDisposed = true;

    // Dispose controllers
    _textController.dispose();
    _animationController.dispose();

    // Remove observers
    WidgetsBinding.instance.removeObserver(this);

    print('   ✅ All resources cleaned up successfully');

    super.dispose();
  }

  // App lifecycle methods (from WidgetsBindingObserver)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('📱 App lifecycle state changed to: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        print('   App is visible and responding to user input');
        break;
      case AppLifecycleState.inactive:
        print('   App is in an inactive state and not receiving user input');
        break;
      case AppLifecycleState.paused:
        print('   App is not currently visible to the user');
        break;
      case AppLifecycleState.detached:
        print('   App is still hosted on a Flutter engine but is detached');
        break;
      case AppLifecycleState.hidden:
        print('   App is hidden from the user');
        break;
    }
  }

  // Helper methods for testing
  void _incrementCounter() {
    setState(() {
      _counter++;
      print('🔢 Counter incremented to: $_counter');
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
      print('🔢 Counter decremented to: $_counter');
    });
  }

  void _testSetState() {
    print('🧪 Testing setState() with multiple operations');

    // Multiple setState calls will be batched
    setState(() {
      _counter += 10;
    });

    setState(() {
      _textController.text = 'Updated at ${DateTime.now()}';
    });

    print('   Multiple setState calls completed');
  }

  void _rebuildWidget() {
    print('🔄 Forcing widget rebuild by calling setState');
    setState(() {
      // This will trigger build() again
    });
  }

  Future<void> _fetchInitialData() async {
    print('🌐 Simulating initial data fetch...');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!_isDisposed) {
      setState(() {
        _counter = 42; // Set initial value from "API"
      });
      print('   ✅ Initial data loaded and UI updated');
    } else {
      print('   ⚠️ Widget was disposed before data loaded');
    }
  }
}

/// A helper widget to test parent-child lifecycle relationships
class LifecycleParentWidget extends StatefulWidget {
  const LifecycleParentWidget({super.key});

  @override
  State<LifecycleParentWidget> createState() => _LifecycleParentWidgetState();
}

class _LifecycleParentWidgetState extends State<LifecycleParentWidget> {
  bool _showChild = true;
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    print('👨‍👦 Parent build() called (rebuild #$_rebuildCount)');

    return Scaffold(
      appBar: AppBar(title: const Text('Parent-Child Lifecycle Test')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Show Child Widget'),
            value: _showChild,
            onChanged: (value) {
              setState(() {
                _showChild = value;
                print('👨‍👦 Parent setState() - Toggling child visibility');
              });
            },
          ),
          ListTile(
            title: const Text('Rebuild Parent'),
            trailing: const Icon(Icons.refresh),
            onTap: () {
              setState(() {
                _rebuildCount++;
                print('👨‍👦 Parent setState() - Rebuilding parent');
              });
            },
          ),
          const Divider(),
          if (_showChild) const TestLifecyclePage(),
        ],
      ),
    );
  }
}
