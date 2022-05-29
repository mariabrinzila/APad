import 'package:flutter/material.dart';

import '../theme/colors.dart';

class PopUpMenu extends StatelessWidget {
  final menuItems = const {
    1: {'name': 'Delete', 'icon': Icons.delete},
    2: {'name': 'Bold', 'icon': Icons.format_bold},
    3: {'name': 'Italic', 'icon': Icons.format_italic},
    4: {'name': 'Underlined', 'icon': Icons.format_underline},
    5: {'name': 'Size +', 'icon': Icons.format_size},
    6: {'name': 'Size -', 'icon': Icons.format_size},
    7: {'name': 'Font DancingScript', 'icon': Icons.title},
    8: {'name': 'Font IndieFlower', 'icon': Icons.title},
    9: {'name': 'Font Pacifico', 'icon': Icons.title},
  };

  final parentContext;
  final void Function(BuildContext, String) onSelect;

  PopUpMenu({
    @required this.parentContext,
    @required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: icons,
      ),
      color: menu,
      itemBuilder: (context) {
        var list = menuItems.entries.map((entry) {
          return PopupMenuItem(
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.3,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      entry.value['icon'],
                      color: icons,
                    ),
                  ),
                  Text(
                    entry.value['name'],
                    style: TextStyle(
                      color: text,
                    ),
                  ),
                ],
              ),
            ),
            value: entry.key,
          );
        }).toList();

        return list;
      },
      onSelected: (value) {
        onSelect(parentContext, menuItems[value]['name']);
      },
    );
  }
}
