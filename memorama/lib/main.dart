import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Forzar la orientación horizontal para la TV
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MemoramaApp());
  });
}

class MemoramaApp extends StatelessWidget {
  const MemoramaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Memorama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MenuInicioScreen(),
    );
  }
}

// ==========================================
// ESTRUCTURA DE DATOS EDUCATIVOS
// ==========================================
class DinoInfo {
  final String rutaImagen;
  final String nombre;
  final String nombreCientifico;
  final String subtitulo;
  final String descripcion;

  const DinoInfo({
    required this.rutaImagen,
    required this.nombre,
    required this.nombreCientifico,
    required this.subtitulo,
    required this.descripcion,
  });
}

// ==========================================
// PANTALLA: MENÚ DE INICIO
// ==========================================
class MenuInicioScreen extends StatelessWidget {
  const MenuInicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      // CAMBIO: Usamos Stack para poder poner botones flotantes en las esquinas
      body: Stack(
        children: [
          // 1. EL CONTENIDO PRINCIPAL (Fondo)
          Row(
            children: [
              // Lado izquierdo del menú
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- NUEVA SECCIÓN: TRES LOGOS SIMÉTRICOS ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // NOTA: Reemplaza estas rutas con las de tus logos reales (ej. 'assets/logo_conacyt.png')
                          _buildMiniLogo('assets/ujat.png'),
                          const SizedBox(width: 25),
                          _buildMiniLogo('assets/DACyTI.png'),
                          const SizedBox(width: 25),
                          _buildMiniLogo('assets/XDevlab.png'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // --- FIN NUEVA SECCIÓN ---

                      const Text(
                        'MEMORAMA\nDINOSAURIOS\nACUATICOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MemoramaScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'INICIAR JUEGO',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lado derecho del menú (Carrusel)
              Expanded(
                flex: 1,
                child: Center(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 350.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                    ),
                    items: [
                      'assets/04_metro.jpeg',
                      'assets/05_mosa.jpeg',
                      'assets/06_noth.jpeg',
                      'assets/07_odon.jpeg',
                      'assets/08_ples.jpeg',
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(i, fit: BoxFit.cover),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          // 2. BOTÓN DE CERRAR APP (Arriba a la derecha)
          Positioned(
            top: 20,
            right: 20,
            child: Material(
              color: Colors.redAccent,
              shape: const CircleBorder(),
              elevation: 4,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                tooltip: 'Cerrar aplicación',
                onPressed: () {
                  // Cierra la aplicación en Android
                  SystemNavigator.pop();
                },
              ),
            ),
          ),

          // 3. BOTÓN DE INFORMACIÓN (Abajo a la izquierda)
          Positioned(
            bottom: 20,
            left: 20,
            child: Material(
              color: Colors.blueAccent,
              shape: const CircleBorder(),
              elevation: 4,
              child: IconButton(
                icon: const Icon(Icons.question_mark, color: Colors.white),
                iconSize: 32,
                tooltip: 'Información',
                onPressed: () {
                  // Abre la ventana de información
                  showDialog(
                    context: context,
                    builder: (context) => const DialogoInformacionApp(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NUEVO MÉTODO: Constructor visual para los mini logos del menú
  Widget _buildMiniLogo(String rutaImagen) {
    return Container(
      width: 150,
      height: 150,
      // CAMBIO: Agregamos padding para encoger el logo dentro del cuadro
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(10, 0, 0, 0),
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
        // Eliminamos el DecorationImage de aquí
      ),
      // CAMBIO: Ponemos la imagen como hijo (child) con BoxFit.contain
      child: Image.asset(
        rutaImagen,
        fit: BoxFit.contain,
      ),
    );
  }
}

// ==========================================
// VENTANA DE INFORMACIÓN DE LA APP (ACTUALIZADO SEGUN BOCETO)
// ==========================================
class DialogoInformacionApp extends StatelessWidget {
  const DialogoInformacionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500, // Ancho fijo para que no sea muy pequeña en la TV
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta la altura al contenido
          children: [
            // FILA SUPERIOR: Título, Logo y Botón de Cerrar (X)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Créditos',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        'Memorama Dinosaurios Acuáticos',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                // Logo
                Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 224, 242,
                        241), // Fondo suave por si la imagen es transparente
                    borderRadius: BorderRadius.circular(2),

                    image: const DecorationImage(
                      // IMPORTANTE: Asegúrate de tener esta imagen o cámbiala por una que exista
                      image: AssetImage(
                          'assets/XDevlab.png'), // Usando una existente como placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Botón Cerrar (X)
                IconButton(
                  icon: const Icon(Icons.close, size: 30, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const Divider(height: 30, thickness: 2),

            // SECCIÓN: Créditos de Desarrollo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCredito(
                  nombre: 'Dra. Erika Yunuen Morales Mateos',
                  cargo: 'Responsable del Desarrollo Tecnológico',
                ),
                const SizedBox(height: 15),
                _buildCredito(
                  nombre: 'Manuel Alejandro Gómez',
                  cargo: 'Desarrollador',
                ),
              ],
            ),

            const SizedBox(height: 25),

            // SECCIÓN: Información de la App (Recuadro)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
              ),
              child: const Text(
                'Este es un juego educativo de memoria diseñado para aprender sobre las criaturas prehistóricas acuáticas. Encuentra los pares para desbloquear información fascinante sobre cada especie.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 25),

            // SECCIÓN: Versión (Parte inferior)
            const Text(
              'Versión 1.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear las filas de créditos fácilmente
  Widget _buildCredito({required String nombre, required String cargo}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nombre,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          cargo,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// PANTALLA: JUEGO
// ==========================================
class MemoramaScreen extends StatefulWidget {
  const MemoramaScreen({super.key});

  @override
  State<MemoramaScreen> createState() => _MemoramaScreenState();
}

class _MemoramaScreenState extends State<MemoramaScreen> {
  final List<DinoInfo> _baseDatosEducativa = const [
    DinoInfo(
      rutaImagen: 'assets/01_crx.jpeg',
      nombre: 'Cretoxyrhina',
      nombreCientifico: 'Cretoxyrhina mantelli',
      subtitulo: 'Cretácico | 90 Ma | 7 metros',
      descripcion:
          'Conocido como el "tiburón Ginsu", fue un gran depredador oceánico que se alimentaba de reptiles marinos y peces gigantes. Sus dientes llegaban a medir más de 7 centímetros.',
    ),
    DinoInfo(
      rutaImagen: 'assets/02_cym.jpeg',
      nombre: 'Cymbospondylus',
      nombreCientifico: 'Cymbospondylus petrinus',
      subtitulo: 'Triásico Medio | 240 Ma | 10 metros',
      descripcion:
          'Uno de los ictiosaurios más grandes de su época. A diferencia de sus parientes posteriores, no tenía aleta dorsal ni cola en forma de media luna, pareciéndose más a una anguila gigante.',
    ),
    DinoInfo(
      rutaImagen: 'assets/03_leed.jpeg',
      nombre: 'Leedsichthys',
      nombreCientifico: 'Leedsichthys problematicus',
      subtitulo: 'Jurásico Medio | 165 Ma | 16 metros',
      descripcion:
          'Un pez óseo colosal que se alimentaba por filtración, similar a las ballenas modernas. Nadaba por los océanos tragando miles de galones de agua para atrapar plancton y pequeños animales.',
    ),
    DinoInfo(
      rutaImagen: 'assets/04_metro.jpeg',
      nombre: 'Metriorhynchus',
      nombreCientifico: 'Metriorhynchus superciliosus',
      subtitulo: 'Jurásico Medio | 155 Ma | 3 metros',
      descripcion:
          'Un cocodrilo totalmente adaptado a la vida marina. Había perdido su pesada armadura para ser más hidrodinámico y sus patas se convirtieron en aletas para nadar velozmente.',
    ),
    DinoInfo(
      rutaImagen: 'assets/05_mosa.jpeg',
      nombre: 'Mosasaurio',
      nombreCientifico: 'Mosasaurus hoffmannii',
      subtitulo: 'Cretácico Superior | 66 Ma | 17 metros',
      descripcion:
          'El superdepredador absoluto de su tiempo. Un lagarto marino emparentado con las serpientes actuales, con mandíbulas formidables capaces de devorar casi cualquier presa en el océano.',
    ),
    DinoInfo(
      rutaImagen: 'assets/06_noth.jpeg',
      nombre: 'Nothosaurus',
      nombreCientifico: 'Nothosaurus mirabilis',
      subtitulo: 'Triásico | 210 Ma | 4 metros',
      descripcion:
          'Un reptil semiacuático parecido a una foca con cuello largo. Probablemente cazaba peces en el agua usando sus afilados dientes, pero descansaba y se reproducía en la costa.',
    ),
    DinoInfo(
      rutaImagen: 'assets/07_odon.jpeg',
      nombre: 'Odontochelys',
      nombreCientifico: 'Odontochelys semitestacea',
      subtitulo: 'Triásico Superior | 220 Ma | 40 cm',
      descripcion:
          'La tortuga más antigua conocida con caparazón parcial. Tenía el plastrón (la parte inferior) duro, pero el lomo blando, sugiriendo que el caparazón de las tortugas evolucionó primero en el agua para protegerse desde abajo.',
    ),
    DinoInfo(
      rutaImagen: 'assets/08_ples.jpeg',
      nombre: 'Plesiosaurio',
      nombreCientifico: 'Plesiosaurus dolichodeirus',
      subtitulo: 'Jurásico Inferior | 195 Ma | 3.5 metros',
      descripcion:
          'Famoso por su pequeño cráneo y cuello excepcionalmente largo. Nadaba batiendo sus cuatro fuertes aletas como si volara bajo el agua, emboscando cardúmenes de peces y calamares.',
    ),
    DinoInfo(
      rutaImagen: 'assets/09_shon.jpeg',
      nombre: 'Shonisaurus',
      nombreCientifico: 'Shonisaurus popularis',
      subtitulo: 'Triásico Superior | 215 Ma | 15 metros',
      descripcion:
          'Un ictiosaurio gigante y rechoncho. A pesar de su enorme tamaño, se cree que los adultos no tenían dientes y atrapaban a sus presas succionándolas de golpe en las oscuras profundidades.',
    ),
    DinoInfo(
      rutaImagen: 'assets/10_tyl.jpeg',
      nombre: 'Tylosaurus',
      nombreCientifico: 'Tylosaurus proriger',
      subtitulo: 'Cretácico Superior | 75 Ma | 14 metros',
      descripcion:
          'Un mosasáurido esbelto y mortífero. Poseía un hocico alargado y cilíndrico que probablemente usaba para embestir y aturdir a sus presas antes de atacarlas con sus terribles mandíbulas.',
    ),
  ];

  List<CardItem> _cartas = [];
  bool _estaProcesandoJugada = false;
  int _paresEncontrados = 0;
  int _intentos = 0;
  CardItem? _primeraCartaSeleccionada;

  String _dificultadActual = 'Media';
  int _columnas = 4;
  int _paresTotales = 8;

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    setState(() {
      _paresEncontrados = 0;
      _intentos = 0;
      _primeraCartaSeleccionada = null;
      _estaProcesandoJugada = false;

      if (_dificultadActual == 'Fácil') {
        _columnas = 3;
        _paresTotales = 6;
      } else if (_dificultadActual == 'Media') {
        _columnas = 4;
        _paresTotales = 8;
      } else {
        _columnas = 5;
        _paresTotales = 10;
      }

      _cartas = [];
      for (int i = 0; i < _paresTotales; i++) {
        _cartas.add(CardItem(informacion: _baseDatosEducativa[i]));
        _cartas.add(CardItem(informacion: _baseDatosEducativa[i]));
      }

      _cartas.shuffle();
    });
  }

  void _voltearCarta(int index) {
    if (_estaProcesandoJugada ||
        _cartas[index].estaVolteada ||
        _cartas[index].estaEncontrada) {
      return;
    }

    setState(() {
      _cartas[index].estaVolteada = true;

      if (_primeraCartaSeleccionada == null) {
        _primeraCartaSeleccionada = _cartas[index];
      } else {
        _intentos++;
        _compararCartas(_cartas[index]);
      }
    });
  }

  void _compararCartas(CardItem segundaCarta) {
    _estaProcesandoJugada = true;

    if (_primeraCartaSeleccionada!.informacion.rutaImagen ==
        segundaCarta.informacion.rutaImagen) {
      setState(() {
        _primeraCartaSeleccionada!.estaEncontrada = true;
        segundaCarta.estaEncontrada = true;
        _paresEncontrados++;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DialogoEducativo(info: segundaCarta.informacion),
      ).then((_) {
        setState(() {
          _primeraCartaSeleccionada = null;
          _estaProcesandoJugada = false;
          _verificarVictoria();
        });
      });
    } else {
      Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          _primeraCartaSeleccionada!.estaVolteada = false;
          segundaCarta.estaVolteada = false;
          _primeraCartaSeleccionada = null;
          _estaProcesandoJugada = false;
        });
      });
    }
  }

  void _verificarVictoria() {
    if (_paresEncontrados == _paresTotales) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('¡Felicidades!', style: TextStyle(fontSize: 28)),
          content: Text('Has completado la colección en $_intentos intentos.',
              style: const TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _iniciarJuego();
              },
              child:
                  const Text('Jugar de nuevo', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child:
                  const Text('Volver al Menú', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubriendo el Océano Prehistórico',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _dificultadActual,
              dropdownColor: Theme.of(context).colorScheme.inversePrimary,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18),
              underline: Container(),
              items: <String>['Fácil', 'Media', 'Alta'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? nuevaDificultad) {
                if (nuevaDificultad != null &&
                    nuevaDificultad != _dificultadActual) {
                  setState(() {
                    _dificultadActual = nuevaDificultad;
                    _iniciarJuego();
                  });
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: _iniciarJuego,
            tooltip: 'Reiniciar juego',
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Intentos: $_intentos',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                Text(
                  'Pares: $_paresEncontrados/$_paresTotales',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final int totalCartas = _cartas.length;
              final int filas = (totalCartas / _columnas).ceil();

              final double anchoDisponible =
                  constraints.maxWidth - (_columnas * 8.0) - 16.0;
              final double altoDisponible =
                  constraints.maxHeight - (filas * 8.0) - 16.0;

              final double anchoCarta = anchoDisponible / _columnas;
              final double altoCarta = altoDisponible / filas;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _columnas,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: anchoCarta / altoCarta,
                  ),
                  itemCount: totalCartas,
                  itemBuilder: (context, index) {
                    return CartaWidget(
                      carta: _cartas[index],
                      onTap: () => _voltearCarta(index),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// VENTANA EMERGENTE EDUCATIVA
// ==========================================
class DialogoEducativo extends StatelessWidget {
  final DinoInfo info;

  const DialogoEducativo({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFCFE2FF),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54, width: 2),
                  image: DecorationImage(
                    image: AssetImage(info.rutaImagen),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${info.nombre} (${info.nombreCientifico})',
                    style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    info.subtitulo,
                    style: const TextStyle(fontSize: 22, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    info.descripcion,
                    style: const TextStyle(
                        fontSize: 18, color: Colors.black87, height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFCA28),
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        side:
                            const BorderSide(color: Colors.black87, width: 1.5),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aprendido',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// COMPONENTES DE LA CARTA
// ==========================================
class CardItem {
  final DinoInfo informacion;
  bool estaVolteada;
  bool estaEncontrada;

  CardItem({
    required this.informacion,
    this.estaVolteada = false,
    this.estaEncontrada = false,
  });
}

class CartaWidget extends StatelessWidget {
  final CardItem carta;
  final VoidCallback onTap;

  const CartaWidget({
    super.key,
    required this.carta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool mostrarFrente = carta.estaVolteada || carta.estaEncontrada;
    final String texturaReverso = 'assets/reverso.jpeg'; // Mantén tu ruta real

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        // La animación va de 0 a 1 (1 representa media vuelta o Pi radianes)
        tween: Tween<double>(begin: 0, end: mostrarFrente ? 1 : 0),
        duration: const Duration(milliseconds: 400), // Velocidad del giro
        builder: (context, double val, child) {
          // Si el valor de giro es menor a 0.5 (mitad del giro), mostramos el reverso.
          // Si es mayor, ya giró lo suficiente para mostrar el frente.
          bool isBack = val < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Esto agrega perspectiva 3D al giro
              ..rotateY(val * math.pi), // Gira sobre el eje Y
            child: isBack
                ? _buildLadoCarta(texturaReverso, false)
                : Transform(
                    alignment: Alignment.center,
                    // Al dar vuelta en 3D la imagen quedaría en modo espejo (al revés).
                    // Esta segunda transformación la "endereza" automáticamente.
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildLadoCarta(
                        carta.informacion.rutaImagen, carta.estaEncontrada),
                  ),
          );
        },
      ),
    );
  }

  // Widget auxiliar para construir el contenedor visual de la carta
  Widget _buildLadoCarta(String rutaImagen, bool estaEncontrada) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54, // Sombra para realzar el efecto 3D
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(rutaImagen),
          fit: BoxFit.cover,
          // Oscurece la imagen ligeramente (40% de negro) si la carta ya fue encontrada
          colorFilter: estaEncontrada
              ? ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken)
              : null,
        ),
      ),
    );
  }
}
