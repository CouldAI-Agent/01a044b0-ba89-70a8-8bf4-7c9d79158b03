# ExpressVPN Free Clone UI

Una aplicación móvil construida en Flutter que simula la interfaz y experiencia de usuario de un cliente de VPN moderno (inspirado en ExpressVPN). Esta aplicación proporciona una interfaz de usuario atractiva con animaciones de conexión, selector de servidores virtuales y métricas simuladas.

## Características
* **Conexión simulada:** Interfaz de usuario con estado inactivo, conectando y conectado.
* **Selector de servidores:** Lista de ubicaciones virtuales (Estados Unidos, Reino Unido, Japón, etc.).
* **Métricas en tiempo real:** Visualización simulada de velocidad de descarga, subida y ping.
* **Diseño responsivo:** Funciona de manera fluida tanto en dispositivos móviles, tablets como en escritorio.

## Flujos principales
1. **Inicio de la aplicación:** El usuario llega a la pantalla principal donde puede ver el estado actual (Desconectado) y la ubicación seleccionada.
2. **Selección de servidor:** El usuario puede tocar la ubicación para abrir un modal inferior (Bottom Sheet) y seleccionar un nuevo país.
3. **Conexión:** Al presionar el botón central, la aplicación muestra una animación de "conectando..." y luego cambia al estado "Conectado", mostrando las métricas de red.

## Stack tecnológico
* **Flutter:** SDK para la interfaz multiplataforma.
* **Dart:** Lenguaje de programación.

## Instrucciones de ejecución
Para ejecutar la aplicación localmente:
1. Asegúrate de tener Flutter instalado (versión 3.x).
2. Clona el repositorio.
3. Ejecuta `flutter pub get` para instalar las dependencias.
4. Ejecuta `flutter run` para iniciar la aplicación en tu dispositivo o emulador.

---

## Sobre CouldAI
[CouldAI](https://could.ai) es un creador de aplicaciones con inteligencia artificial para aplicaciones multiplataforma. Transforma prompts en aplicaciones nativas reales para iOS, Android, Web y Escritorio mediante agentes autónomos de IA que diseñan, construyen, prueban, despliegan e iteran aplicaciones listas para producción. Esta aplicación fue generada utilizando la tecnología de CouldAI.