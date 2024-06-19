import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/constants/urlAPI.dart';
import 'package:qr_code/page/home.dart';
import 'package:qr_code/page/login.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartment;
  String? _avatarUrl;
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
        final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];
        final imageUrl = data['avatar'];
        setState(() {
          _userData = data;
          _usernameController.text = _userData!['username'];
          _firstNameController.text = _userData!['firstname'];
          _lastNameController.text = _userData!['lastname'];
          _phoneController.text = _userData!['phone'];
          _positionController.text = _userData!['position'];
          _addressController.text = _userData!['address'];
          _emailController.text = _userData!['email'];
          _selectedDepartment = _userData!['department'];
          _avatarUrl = imageUrl;
          print(_avatarUrl);
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

  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     String fullPath = pickedFile.path;
  //     String fileName = fullPath
  //         .split('/')
  //         .last; // Using split to get the last segment after the slash
  //     print("Extracted filename: $fileName");
  //     setState(() {
  //       _image = File(fullPath);
  //       _imagePath = fileName;
  //     });
  //     await _saveImageToAssets(_image!);
  //   }
  // }

  // Future<void> _saveImageToAssets(File imageFile) async {
  //   final appDir = await getApplicationDocumentsDirectory();
  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   final savedImage = await imageFile.copy('${appDir.path}/$fileName.jpg');
  //   // Move the image to the assets folder
  //   final directory = Directory('${appDir.path}/assets');
  //   print('directory: $directory || dir: ${appDir.path} || $fileName');
  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }
  //   await savedImage.copy('${directory.path}/$fileName');
  //   setState(() {
  //     _image = File('${directory.path}/$fileName');
  //   });
  // }

  Future<void> logout() async {
    // Retrieve the token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
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

  Future<void> updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String selectedDepartment =
          _selectedDepartment ?? _userData?['department'];
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final String apiUrl = '$apiUser/$userId';

      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
      request.headers['Content-Type'] = 'multipart/form-data';
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('avatar', _image!.path));
      }
      request.fields['firstname'] = _firstNameController.text;
      request.fields['lastname'] = _lastNameController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['position'] = _positionController.text;
      request.fields['address'] = _addressController.text;
      request.fields['email'] = _emailController.text;
      request.fields['department'] = selectedDepartment;
      final response = await request.send();
      if (response.statusCode == 200) {
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
      } else {
        CustomDialog.showDialog(context, 'Cập nhật thất bại!', "error");
      }
    } else {
      CustomDialog.showDialog(
          context, 'Đã xảy ra lỗi. \n Xin vui lòng thử lại.', "error");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading ? null : const HeaderApp(title: 'User Detail'),
      body: _isLoading
          ? CustomLoading()
          : Container(
              color: bgColor,
              width: double.infinity,
              height: double.infinity,
              padding: AppStyles.paddingContainer,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          _pickImage();
                        },
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
                                    : (_userData?['avatar'] != null &&
                                            _avatarUrl != null)
                                        ? Image.network(
                                            '$api/$_avatarUrl',
                                            fit: BoxFit.cover,
                                          )
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
                              onPressed: () {
                                _pickImage();
                              },
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
                        onSaved: (newValue) {
                          _selectedDepartment = newValue;
                        },
                      ),
                      Container(
                        margin: AppStyles.marginButton,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomButton(
                              text: 'Update',
                              onPressed: () {
                                updateUser();
                              },
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
            ),
    );
  }
}

class UpdateUserData {
  final String? avatar;
  final String firstname;
  final String lastname;
  final String phone;
  final String position;
  final String address;
  final String email;
  final String department;

  UpdateUserData({
    this.avatar,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.position,
    required this.address,
    required this.email,
    required this.department,
  });

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'position': position,
      'address': address,
      'email': email,
      'department': department,
    };
  }
}
