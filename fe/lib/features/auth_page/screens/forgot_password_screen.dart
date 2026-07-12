import 'package:flutter/material.dart';
import 'package:morsequest/features/auth_page/widgets/auth_widgets.dart';
import 'package:morsequest/features/auth_page/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;

  void _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _isSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF005A9C),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const AuthHeader(),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005A9C),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masukkan email yang terdaftar,\nkami akan kirimkan link reset password',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                if (!_isSubmitted) ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'contoh@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!value.contains('@')) {
                              return 'Email tidak valid';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthButton(
                    onPressed: _sendResetEmail,
                    isLoading: _isLoading,
                    text: 'KIRIM LINK RESET',
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF005A9C),
                      ),
                      child: const Text(
                        'Kembali ke Login',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],

                if (_isSubmitted) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Email Terkirim!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Link reset password telah dikirim ke\n${_emailController.text}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD500),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'KEMBALI KE LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
