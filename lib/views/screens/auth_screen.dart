import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:traxi/middleware/auth/bloc/auth_bloc.dart';
import 'package:traxi/views/screens/tabs.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;
  var _isPasswordObscured = true;

  final _form = GlobalKey<FormState>();

  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _authenticate() {
    final isValid = _form.currentState!.validate();
    if(!isValid) return;

    _form.currentState!.save();

    if(_isLogin) {
      context.read<UserAuthBloc>().add(
        SignInEvent(
          email: _enteredEmail,
          password: _enteredPassword
        )
      );
    } else {
      context.read<UserAuthBloc>().add(
        SignUpEvent(
          email: _enteredEmail,
          firstName: _enteredFirstName,
          lastName: _enteredLastName,
          password: _enteredPassword
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listener: (context, state) {
        if (state is UserAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is UserAuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication successful!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const TabScreen(),
            ),
          );
        }
      },
      child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _isLogin ? 'Hello, Welcome Back 👋' : 'Create Account 👋',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 40),
                
                    // First Name Field
                    if(!_isLogin)
                      Text(
                        'First Name',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (!_isLogin) const SizedBox(height: 8),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('firstName'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                        onSaved: (value) => _enteredFirstName = value!,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    if (!_isLogin) const SizedBox(height: 20),
                
                    // Last Name Field
                    if(!_isLogin)
                      Text(
                        'Last Name',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (!_isLogin) const SizedBox(height: 8),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('lastName'),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            width: 2
                          )
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        ),
                        onSaved: (value) => _enteredLastName = value!,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),

                    if (!_isLogin) const SizedBox(height: 20),
                
                    // Email Field
                    Text(
                      'Email Address',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const ValueKey('email'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            width: 2
                          )
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      onSaved: (value) => _enteredEmail = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                
                    // Password Field
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const ValueKey('password'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            width: 2
                          )
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded
                          ),
                          onPressed: () {
                            setState(() => _isPasswordObscured = !_isPasswordObscured);
                          },
                        )
                      ),
                      obscureText: _isPasswordObscured,
                      onSaved: (value) => _enteredPassword = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim().length < 6) {
                          return 'Password must be at least 5 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                
                    // Login/Create Account Button
                    BlocBuilder<UserAuthBloc, UserAuthState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: state is! UserAuthLoading ? _authenticate: null,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: state is UserAuthLoading
                              ? Center( 
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                )
                              : Center(
                                child: Text(
                                    _isLogin ? 'Login' : 'Register',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                
                    // Create Account/Login Button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Create an Account' : 'I already have an account',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
    );
  }
}
