import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    if (widget.userData != null) {
      nameController.text = widget.userData!['userName'] ?? '';
      emailController.text = widget.userData!['userEmail'] ?? '';
      phoneController.text = widget.userData!['userPhoneNumber'] ?? '';
    }
  }

  void saveProfile() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    try {
      final success = await ApiService.updateProfile(name, email, phone);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật thông tin thành công")),
        );
        setState(() => isEditing = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật thất bại")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi kết nối")),
      );
    }
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc muốn đăng xuất?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ cá nhân"),
        leading: const BackButton(),
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: () => setState(() => isEditing = true),
              icon: const Icon(Icons.edit),
            )
          else
            IconButton(
              onPressed: saveProfile,
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 30),

            // Tên
            TextField(
              controller: nameController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: "Họ và tên",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Số điện thoại
            TextField(
              controller: phoneController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),

            // Nút đăng xuất
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}