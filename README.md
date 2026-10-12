# TecnoStore
**Evaluación Unidad 3 – Computación Móvil**  
**Universidad Mayor**

## Descripción del proyecto

TecnoStore es una aplicación de comercio electrónico desarrollada con Flutter y Firebase, orientada a la venta de productos tecnológicos.

La aplicación permite a los usuarios registrarse, iniciar sesión, consultar un catálogo de productos, buscar artículos, filtrar por categorías y administrar un carrito de compras.

## Tecnologías utilizadas

- **Flutter y Dart:** desarrollo de la interfaz de usuario.
- **Firebase Authentication:** registro e inicio de sesión.
- **Cloud Firestore:** almacenamiento y consulta de productos, precios y existencias.
- **Firebase Cloud Functions:** estructura inicial del backend, pendiente de implementar y desplegar.
- **Git y GitHub:** control de versiones y publicación del código.

## Funcionalidades implementadas

- Registro e inicio de sesión mediante Firebase Authentication.
- Catálogo de seis productos almacenados en Cloud Firestore.
- Consulta de productos desde Firebase.
- Visualización de nombre, precio, categoría y stock.
- Búsqueda de productos por nombre.
- Filtros por categorías: Audio, Computación y Accesorios.
- Visualización del detalle de cada producto.
- Carrito de compras con opción de agregar y eliminar productos.
- Cálculo del total de la compra.
- Validación básica de cantidades disponibles en el carrito.
- Simulación del proceso de compra.

## Productos disponibles

| Producto | Categoría | Precio |
|---|---|---:|
| Audífonos Bluetooth | Audio | $24.990 |
| Mouse inalámbrico | Computación | $12.990 |
| Teclado mecánico | Computación | $39.990 |
| Cargador USB-C | Accesorios | $14.990 |
| Parlante Bluetooth | Audio | $29.990 |
| Cable USB-C | Accesorios | $5.990 |

Los precios y las existencias son consultados desde Cloud Firestore.

## Ejecución del proyecto

**Requisitos:** Flutter SDK, Dart y acceso a un proyecto Firebase configurado.

Desde la carpeta principal del proyecto, ejecutar:

```bash
flutter pub get
flutter run -d chrome
```

Para revisar el código:

```bash
flutter analyze
```

La aplicación requiere una configuración válida de Firebase y conexión a internet para utilizar la autenticación y consultar los productos.

## Funcionalidades pendientes

- Registrar compras reales en Firestore.
- Actualizar el stock de los productos mediante un servicio de backend seguro.
- Implementar y desplegar los servicios de Firebase Cloud Functions.
- Realizar pruebas de los servicios mediante Postman.
- Verificar el funcionamiento en un emulador Android.

**Nota:** el proceso de compra actual es una simulación y no registra ventas ni modifica las existencias almacenadas en Firebase.

## Repositorio

https://github.com/Hanta86/TecnoStore