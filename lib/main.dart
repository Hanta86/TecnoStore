import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TecnoStoreApp());
}

class Producto {
  final int id;
  final String nombre;
  final String categoria;
  final int precio;
  final IconData icono;
  final String descripcion;
  int stock;
  Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.icono,
    required this.descripcion,
    required this.stock,
  });
}

class TecnoStoreApp extends StatelessWidget {
  const TecnoStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TecnoStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const TiendaPage();
          }

          return const AuthPage();
        },
      ),
    );
  }
}

class TiendaPage extends StatefulWidget {
  const TiendaPage({super.key});

  @override
  State<TiendaPage> createState() => _TiendaPageState();
}

class _TiendaPageState extends State<TiendaPage> {
  final List<Producto> productos = [
    Producto(
      id: 1,
      nombre: 'Audífonos Bluetooth',
      categoria: 'Audio',
      precio: 24990,
      icono: Icons.headphones,
      descripcion: 'Audífonos inalámbricos con sonido estéreo.',
      stock: 10,
    ),
    Producto(
      id: 2,
      nombre: 'Mouse inalámbrico',
      categoria: 'Computación',
      precio: 12990,
      icono: Icons.mouse,
      descripcion: 'Mouse ergonómico con conexión inalámbrica.',
      stock: 15,
    ),
    Producto(
      id: 3,
      nombre: 'Teclado mecánico',
      categoria: 'Computación',
      precio: 39990,
      icono: Icons.keyboard,
      descripcion: 'Teclado mecánico con iluminación LED.',
      stock: 8,
    ),
    Producto(
      id: 4,
      nombre: 'Cargador USB-C',
      categoria: 'Accesorios',
      precio: 14990,
      icono: Icons.battery_charging_full,
      descripcion: 'Cargador rápido compatible con USB-C.',
      stock: 20,
    ),
    Producto(
      id: 5,
      nombre: 'Parlante Bluetooth',
      categoria: 'Audio',
      precio: 29990,
      icono: Icons.speaker,
      descripcion: 'Parlante portátil con conexión Bluetooth.',
      stock: 6,
    ),
    Producto(
      id: 6,
      nombre: 'Cable USB-C',
      categoria: 'Accesorios',
      precio: 5990,
      icono: Icons.cable,
      descripcion: 'Cable USB-C para carga y transferencia.',
      stock: 25,
    ),
  ];

  final Map<int, int> carrito = {};
  String busqueda = '';
  String categoria = 'Todas';

  String precioCLP(int valor) {
    final texto = valor.toString();
    return '\$${texto.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void agregarCarrito(Producto producto) {
    final cantidadActual = carrito[producto.id] ?? 0;

    if (cantidadActual >= producto.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay más stock disponible')),
      );
      return;
    }

    setState(() {
      carrito[producto.id] = cantidadActual + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${producto.nombre} agregado al carrito')),
    );
  }

  void mostrarDetalle(Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(producto.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(producto.icono, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text(producto.descripcion),
            const SizedBox(height: 12),
            Text('Precio: ${precioCLP(producto.precio)}'),
            Text('Stock disponible: ${producto.stock}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              agregarCarrito(producto);
            },
            child: const Text('Agregar al carrito'),
          ),
        ],
      ),
    );
  }

  void mostrarCarrito() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, actualizarCarrito) {
          final seleccionados = productos
              .where((p) => carrito.containsKey(p.id))
              .toList();

          final total = seleccionados.fold<int>(
            0,
            (suma, p) => suma + p.precio * (carrito[p.id] ?? 0),
          );

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Carrito de compras',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (seleccionados.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Tu carrito está vacío'),
                    ),
                  ...seleccionados.map(
                    (p) => ListTile(
                      leading: Icon(p.icono),
                      title: Text(p.nombre),
                      subtitle: Text(
                        '${carrito[p.id]} x ${precioCLP(p.precio)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => carrito.remove(p.id));
                          actualizarCarrito(() {});
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Total: ${precioCLP(total)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (seleccionados.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final sinStock = seleccionados
                              .where((p) => (carrito[p.id] ?? 0) > p.stock)
                              .toList();

                          if (sinStock.isNotEmpty) {
                            setState(() {
                              for (final p in sinStock) {
                                carrito.remove(p.id);
                              }
                            });
                            actualizarCarrito(() {});
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Productos sin stock eliminados del carrito',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            for (final p in seleccionados) {
                              p.stock -= carrito[p.id]!;
                            }
                            carrito.clear();
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Compra simulada correctamente'),
                            ),
                          );
                        },
                        child: const Text('Comprar'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = productos.where((p) {
      final coincideNombre = p.nombre.toLowerCase().contains(
        busqueda.toLowerCase(),
      );
      final coincideCategoria =
          categoria == 'Todas' || p.categoria == categoria;
      return coincideNombre && coincideCategoria;
    }).toList();

    final cantidadCarrito = carrito.values.fold<int>(
      0,
      (suma, cantidad) => suma + cantidad,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: const Text('TecnoStore'),
        actions: [
          Badge(
            label: Text('$cantidadCarrito'),
            isLabelVisible: cantidadCarrito > 0,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: mostrarCarrito,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar productos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() => busqueda = valor);
              },
            ),
          ),
          SizedBox(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['Todas', 'Audio', 'Computación', 'Accesorios'].map((
                c,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: categoria == c,
                    onSelected: (_) {
                      setState(() => categoria = c);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filtrados.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          mainAxisExtent: 235,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final producto = filtrados[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Icon(
                                producto.icono,
                                size: 52,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                producto.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(precioCLP(producto.precio)),
                              Text('Stock: ${producto.stock}'),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Ver detalle',
                                    onPressed: () => mostrarDetalle(producto),
                                    icon: const Icon(Icons.info_outline),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: producto.stock > 0
                                        ? () => agregarCarrito(producto)
                                        : null,
                                    child: const Text('Agregar'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
