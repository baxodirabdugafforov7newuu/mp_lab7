import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html'; // allowed for web
import 'task11.dart';

// Global URL for all tasks
const String url = 'https://jsonplaceholder.typicode.com/posts';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Tasks Demo',
      home: MyHomePage(title: 'Task Runner'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Task 2
          ElevatedButton(
            onPressed: () async => await Task2().run(),
            child: const Text('Run Task 2'),
          ),
          const SizedBox(height: 10),

          // Task 3
          ElevatedButton(
            onPressed: () async => await Task3().run(),
            child: const Text('Run Task 3'),
          ),
          const SizedBox(height: 10),

          // Task 4
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Task4()),
              );
            },
            child: const Text('Open Task 4 Screen'),
          ),
          const SizedBox(height: 10),

          // Task 5
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Task5()),
              );
            },
            child: const Text('Open Task 5 (Loader Example)'),
          ),
          const SizedBox(height: 10),

          // Task 6
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Task6()),
              );
            },
            child: const Text('Open Task 6 (Error + Retry)'),
          ),
          const SizedBox(height: 10),

          // Task 7 and 8 as Task78
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Task78()),
              );
            },
            child: const Text('Open Task 7 and 8 (Details Navigation)'),
          ),
          const SizedBox(height: 10),

          // Task 9 and 10 as Task910
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Task910()),
              );
            },
            child: const Text('Open Task 9'),
          ),

          // Task 11
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Task11()),
              );
            },
            child: const Text('Open Task 9'),
          ),
        ],
      ),
    );
  }
}

// Task 2

class Task2 {
  Future<void> run() async {
    try {
      final response = await HttpRequest.getString(url);
      final List<dynamic> jsonList = jsonDecode(response);
      final posts = jsonList.map((e) => Map<String, dynamic>.from(e)).toList();

      print('First 3 posts:\n');
      for (int i = 0; i < 3 && i < posts.length; i++) {
        print(posts[i]);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

// Task 3

class Task3 {
  Future<void> run() async {
    try {
      final response = await HttpRequest.getString(url);
      var data = jsonDecode(response);
      print('First post title: ${data[0]['title']}');
    } catch (e) {
      print('Error: $e');
    }
  }
}

// Task 4

class Task4 extends StatefulWidget {
  const Task4({super.key});

  @override
  State<Task4> createState() => _Task4State();
}

class _Task4State extends State<Task4> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await HttpRequest.getString(url);
      setState(() => posts = jsonDecode(response));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Post Titles')),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) =>
                  ListTile(title: Text(posts[index]['title'])),
            ),
    );
  }
}

// Task 5

class Task5 extends StatefulWidget {
  const Task5({super.key});

  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await HttpRequest.getString(url);
      setState(() {
        posts = jsonDecode(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 5: Loading Example')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) =>
                    ListTile(title: Text(posts[index]['title'])),
              ),
      ),
    );
  }
}

// Task 6

class Task6 extends StatefulWidget {
  const Task6({super.key});

  @override
  State<Task6> createState() => _Task6State();
}

class _Task6State extends State<Task6> {
  List posts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Simulate a possible network issue:
      // throw Exception('Network failed!'); // uncomment to test retry

      final response = await HttpRequest.getString(url);
      final data = jsonDecode(response);

      setState(() {
        posts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again.';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) =>
            ListTile(title: Text(posts[index]['title'])),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Task 6: Error Handling + Retry')),
      body: content,
    );
  }
}

// Task 7 and 8 as Task78

class Task78 extends StatefulWidget {
  const Task78({super.key});

  @override
  State<Task78> createState() => _Task78State();
}

class _Task78State extends State<Task78> {
  List<dynamic> posts = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await HttpRequest.getString(url);
      setState(() {
        posts = jsonDecode(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 7 & 8 — Posts')),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to load posts.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    post['title'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetails(
                          title: post['title'],
                          body: post['body'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PostDetails extends StatelessWidget {
  final String title;
  final String body;

  const PostDetails({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context), // Extra back button
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Task 9 and 10 as Task910
class Task910 extends StatefulWidget {
  const Task910({super.key});

  @override
  State<Task910> createState() => _Task910State();
}

class _Task910State extends State<Task910> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  bool isSubmitting = false;

  Future<void> submitPost() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields.')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      const String url = 'https://reqres.in/api/posts';
      final String payload = jsonEncode({'title': title, 'body': body});

      final request = await HttpRequest.request(
        url,
        method: 'POST',
        sendData: payload,
        requestHeaders: {'Content-Type': 'application/json'},
        withCredentials: false,
      );

      print('Response: ${request.responseText}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post submitted successfully.')),
      );

      titleController.clear();
      bodyController.clear();
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send post. Try again.')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 9 & 10 — Submit Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a New Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Body',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSubmitting ? null : submitPost,
              child: Text(isSubmitting ? 'Submitting...' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

