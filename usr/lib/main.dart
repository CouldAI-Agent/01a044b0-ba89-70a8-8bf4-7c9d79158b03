import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const VpnApp());
}

class VpnApp extends StatelessWidget {
  const VpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Express Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red.shade700,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isConnected = false;
  bool isConnecting = false;
  String currentServer = 'Estados Unidos - Nueva York';
  late AnimationController _animationController;

  final List<String> servers = [
    'Estados Unidos - Nueva York',
    'Estados Unidos - Miami',
    'Reino Unido - Londres',
    'Alemania - Frankfurt',
    'Japón - Tokio',
    'Brasil - São Paulo',
    'España - Madrid',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleConnection() {
    if (isConnected) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnecting = true;
      });
      
      // Simular tiempo de conexión
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isConnecting = false;
            isConnected = true;
          });
        }
      });
    }
  }

  void _showServerSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Ubicación',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: servers.length,
                  itemBuilder: (context, index) {
                    final server = servers[index];
                    final isSelected = server == currentServer;
                    return ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: isSelected ? Colors.red.shade400 : Colors.grey,
                      ),
                      title: Text(
                        server,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade300,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected 
                        ? Icon(Icons.check_circle, color: Colors.red.shade400)
                        : null,
                      onTap: () {
                        setState(() {
                          currentServer = server;
                          // Si estaba conectado, reconectar al cambiar de servidor
                          if (isConnected) {
                            isConnected = false;
                            toggleConnection();
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      if (isConnecting) return Colors.orange;
      if (isConnected) return Colors.green.shade400;
      return Colors.red.shade400;
    }

    String getStatusText() {
      if (isConnecting) return 'Conectando...';
      if (isConnected) return 'Conectado';
      return 'Desconectado';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Express Connect', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuraciones no disponibles en esta versión demo')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Estado de la conexión
            Text(
              getStatusText(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: getStatusColor(),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botón central de conexión
            GestureDetector(
              onTap: isConnecting ? null : toggleConnection,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Anillo animado si está conectando
                  if (isConnecting)
                    RotationTransition(
                      turns: _animationController,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.5),
                            width: 8,
                          ),
                        ),
                      ),
                    ),
                  
                  // Anillo exterior
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getStatusColor().withOpacity(0.2),
                    ),
                  ),
                  
                  // Botón interior
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getStatusColor(),
                      boxShadow: [
                        BoxShadow(
                          color: getStatusColor().withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.power_settings_new,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Selector de ubicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: InkWell(
                onTap: _showServerSelection,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.public, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ubicación actual',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentServer,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Datos simulados en la parte inferior
            if (isConnected)
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDataRow(Icons.download, 'Descarga', '120.5 Mbps', Colors.green),
                    Container(width: 1, height: 40, color: Colors.grey.shade800),
                    _buildDataRow(Icons.upload, 'Subida', '45.2 Mbps', Colors.blue),
                  ],
                ),
              )
            else
              const SizedBox(height: 70), // Espaciador para mantener el layout estático
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
