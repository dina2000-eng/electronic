import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton(
      {Key? key,
      required this.function,
      required this.icon,
      this.iconColor,
      this.isMini = true,
      this.elevation = 0})
      : super(key: key);
  final Function? function;
  final IconData icon;
  final Color? iconColor;
  final bool isMini;
  final double elevation;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: const Uuid().v4(),
      elevation: elevation,
      mini: isMini,
      onPressed: () {
        if (function == null) {
          null;
          return;
        }
        function!();
      },
      child: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
    );
    // ButtonStyle(
    //   shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
    //     (_) {
    //       return RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(12),
    //       );
    //     },
    //   ),
    // ),
  }
}

// Iconbutton

//  IconButton(
//         onPressed: () {
//           if (function == null) {
//             null;
//             return;
//           }
//           function!();
//         },
//         icon: Icon(
//           icon,
//           color: iconColor,
//           size: 20,
//         ),
//         style: IconButton.styleFrom(
//           backgroundColor: Theme.of(context).cardColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ));

// //////////////////////////////////
// Padding(
//   padding: const EdgeInsets.all(4.0),
//   child: GestureDetector(
//     onTap: () {
//       if (function == null) {
//         null;
//         return;
//       }
//       function!();
//     },
//     child: Container(
//       width: kToolbarHeight - 15,
//       height: kToolbarHeight - 15,
//       margin: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Theme.of(context).secondaryHeaderColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       alignment: Alignment.center,
//       child: Icon(
//         icon,
//         color: iconColor, //  ?? Utils(context).color
//         size: 20,
//       ),
//     ),
// //////////////
//  Container(
//   decoration: BoxDecoration(
//     // shape: BoxShape.circle,
//     borderRadius: BorderRadius.circular(12),
//     color: Theme.of(context).colorScheme.background.withOpacity(0.7),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(6.0),
//     child: Icon(
//       icon,
//       size: 16,
//       // color: Theme.of(context).iconTheme.color,
//     ),
//   ),
// ),
//       ),
//     );
//   }
// }
/***
 * import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton(
      {Key? key, required this.function, required this.icon})
      : super(key: key);
  final Function? function;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(2.h),
        backgroundColor: Colors.green, // <-- Button color
        foregroundColor: Colors.red, // <-- Splash color
      ),
      child: const Icon(
        IconlyBold.plus,
        size: 18,
        color: Colors.white,
      ),
    );
  }
}
 */
