import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/constants/urlAPI.dart';
import 'package:qr_code/page/login.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      print('User ID not found');
      return;
    }
    try {
      final response = await http.get(Uri.parse('$apiUser/$userId'));

      if (response != null) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _userData = data;
          _usernameController.text = _userData!['username'];
          _firstNameController.text = _userData!['firstname'];
          _lastNameController.text = _userData!['lastname'];
          _phoneController.text = _userData!['phone'];
          _positionController.text = _userData!['position'];
          _addressController.text = _userData!['address'];
          _emailController.text = _userData!['email'];
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> logout() async {
    // Retrieve the token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    Navigator.popAndPushNamed(context, Routes.login);
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: 'User Detail'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: bgColor,
              width: double.infinity,
              height: double.infinity,
              padding: AppStyles.paddingContainer,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      child: Stack(children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: _image != null
                                  ? Image.file(_image!, fit: BoxFit.cover)
                                  : Image.asset(
                                      'assets/avatar-user.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        )
                      ]),
                    ),
                    buildTextFieldRow(
                      labelText: 'User ID',
                      hintText: 'user_id',
                      controller: _usernameController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Họ',
                      isEnable: true,
                      hintText: 'Họ',
                      icon: Icons.edit,
                      controller: _lastNameController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Tên',
                      isEnable: true,
                      hintText: 'Tên',
                      icon: Icons.edit,
                      controller: _firstNameController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Điện Thoại',
                      isEnable: true,
                      hintText: 'Điện Thoại',
                      icon: Icons.edit,
                      controller: _phoneController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Chức Vụ',
                      isEnable: true,
                      hintText: 'Chức Vụ',
                      icon: Icons.edit,
                      controller: _positionController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Địa Chỉ',
                      isEnable: true,
                      hintText: 'Địa Chỉ',
                      icon: Icons.edit,
                      controller: _addressController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Gmail',
                      isEnable: true,
                      hintText: 'Gmail',
                      icon: Icons.edit,
                      controller: _emailController,
                    ),
                    Dropdownbutton(
                      items: ['Kho', 'Sản Xuất', 'Nhập Hàng', 'Xuất Hàng'],
                      hintText: _userData?['department'] ?? '',
                      labelText: 'Phòng Ban',
                      databaseText: _userData?['department'] ?? '',
                    ),
                    Container(
                      margin: AppStyles.marginButton,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                            text: 'Update',
                            onPressed: () {},
                          ),
                          CustomButton(
                            text: 'logout',
                            onPressed: () {
                              logout();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
