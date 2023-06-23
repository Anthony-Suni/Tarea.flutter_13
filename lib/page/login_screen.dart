import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/learn.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 500),
                  crossFadeState: showLogin
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: LoginWidget(
                      toggleView: toggleView), // Agrega el widget LoginWidget
                  secondChild: RegisterWidget(
                      toggleView:
                          toggleView), // Agrega el widget RegisterWidget
                ),
                Positioned(
                  top: -30,
                  right: -30,
                  child: GestureDetector(
                    key: ValueKey(showLogin ? "loginButton" : "registerButton"),
                    onTap: toggleView,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: 60,
                      height: 60,
                      child: Icon(
                        showLogin ? Icons.add : Icons.close,
                        color: Colors.white,
                      ),
                    ),
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

class LoginWidget extends StatelessWidget {
  final void Function() toggleView;

  const LoginWidget({Key? key, required this.toggleView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  // Validación del campo de nombre de usuario
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  // Validación del campo de contraseña
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para procesar el inicio de sesión
                        if (Form.of(context)!.validate()) {
                          // Validación exitosa, realizar inicio de sesión
                          // Aquí puedes agregar tu lógica de autenticación
                          // y realizar cualquier acción necesaria
                        }
                      },
                      child: Text('GO'),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Lógica para el enlace "Forgot your password?"
                  // Aquí puedes agregar tu lógica para recuperar la contraseña
                },
                child: const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RegisterWidget extends StatefulWidget {
  final void Function() toggleView;

  const RegisterWidget({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;
  String? _registrationMessage;
  bool _isConnectedToBackend = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('http://localhost:27017/api/register'),
          body: {
            'username': username,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          // Registro exitoso
          setState(() {
            _registrationMessage = '¡Registro exitoso!'; // Mensaje de éxito
          });
          _usernameController.clear();
          _passwordController.clear();
        } else if (response.statusCode == 400) {
          // Registro fallido debido a datos inválidos
          setState(() {
            _usernameError = 'Nombre de usuario inválido';
            _passwordError = 'Contraseña inválida';
            _registrationMessage = null; // Reinicia el mensaje de registro
            // Agrega más mensajes de error según corresponda
          });
        } else {
          // Registro fallido debido a un error en el servidor
          setState(() {
            _registrationMessage =
                'Error en el registro. Por favor, inténtalo de nuevo más tarde.';
          });
        }
      } catch (e) {
        // Handle any errors that occur during the registration process
        setState(() {
          _registrationMessage = 'Ocurrió un error durante el registro.';
        });
      }
    }
  }

  void _connectToBackend() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:4000/api/endpoint'));

      if (response.statusCode == 200) {
        // La conexión fue exitosa
        setState(() {
          _isConnectedToBackend = true;
        });
      } else {
        // La conexión falló
        setState(() {
          _isConnectedToBackend = false;
        });
      }
    } catch (e) {
      // Ocurrió un error durante la conexión
      setState(() {
        _isConnectedToBackend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'REGISTRO',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  errorText: _usernameError,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa tu nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  errorText: _passwordError,
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Repetir contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor repite tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                child: const Text('SIGUIENTE'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: widget.toggleView,
                child: const Text(
                  '¿Ya tienes una cuenta? Iniciar sesión',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              // Mostrar mensaje de registro
              if (_registrationMessage != null)
                Text(
                  _registrationMessage!,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              // Mostrar mensaje de conexión al backend
              if (_isConnectedToBackend)
                Text(
                  '¡Conectado al backend!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
