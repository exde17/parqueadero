import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMario(BuildContext context, String message) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.018),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.blueAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container(
        //   width: MediaQuery.of(context).size.width * 0.06, // Ancho del ícono
        //   height: MediaQuery.of(context).size.width * 0.06,
        //   decoration: const BoxDecoration(
        //     // color: Colors.red, // Color de fondo del contenedor, puedes quitar esta línea si no la necesitas
        //     image: DecorationImage(
        //       image: AssetImage('lib/assets/logoHumanSave_transparent.png'),
        //       // Puedes usar `fit: BoxFit.cover` o algún otro BoxFit para controlar cómo se muestra la imagen dentro del espacio asignado
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        // Image.asset('lib/assets/logoHumanSave_transparent.png'),
        // const Icon(Icons.'lib/assets/logoHumanSave_transparent.png', color: Colors.white),
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.015,
        ),
        Flexible(
          // Asegura que el texto se ajuste dentro del espacio disponible
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
            softWrap: true, // Permite que el texto pase a la siguiente línea
            overflow: TextOverflow.visible, // Asegura que el texto no se corte
          ),
        )
        // Text(message, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// void showCustomToastWithIcon(BuildContext context, String message) {
//   FToast fToast = FToast();
//   fToast.init(context);

//   Widget toast = Container(
//     padding: EdgeInsets.symmetric(
//         horizontal: MediaQuery.of(context).size.width * 0.04,
//         vertical: MediaQuery.of(context).size.height * 0.02),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(25.0),
//       color: Colors.blueAccent,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.2),
//           spreadRadius: 1,
//           blurRadius: 10,
//           offset: const Offset(0, 5),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.08,
//           height: MediaQuery.of(context).size.width * 0.08,
//           // decoration: const BoxDecoration(
//           //   image: DecorationImage(
//           //     image: AssetImage('lib/assets/logoHumanSave_transparent.png'),
//           //     fit: BoxFit.fill,
//           //   ),
//           // ),
//         ),
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.03,
//         ),
//         Flexible(
//           child: Text(
//             message,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//             softWrap: true,
//             overflow: TextOverflow.visible,
//           ),
//         ),
//       ],
//     ),
//   );

//   fToast.showToast(
//     child: toast,
//     gravity: ToastGravity.BOTTOM,
//     toastDuration: const Duration(seconds: 2),
//   );
// }
