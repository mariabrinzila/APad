import 'package:flutter/material.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A,
    c8 = 0x3300B1CC,
    c9 = 0xCCFF595E;

// More Menu to display various options like Color, Sort, Share...
class appBarPopMenu extends StatelessWidget {
  final popupMenuButtonItems = const {
    1: {'name': 'Delete', 'icon': Icons.delete},
    2: {'name': 'Bold', 'icon': Icons.format_bold},
    3: {'name': 'Italic', 'icon': Icons.format_italic},
    4: {'name': 'Underlined', 'icon': Icons.format_underline},
    5: {'name': 'Size', 'icon': Icons.format_size},
    6: {'name': 'Font', 'icon': Icons.text_fields},
  };
  final parentContext;
  final void Function(BuildContext, String) onSelectPopupmenuItem;

  appBarPopMenu({
    @required this.parentContext,
    @required this.onSelectPopupmenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: const Color(c1),
      ),
      color: Color(c1),
      itemBuilder: (context) {
        var list = popupMenuButtonItems.entries.map((entry) {
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
                      color: const Color(c3),
                    ),
                  ),
                  Text(
                    entry.value['name'],
                    style: TextStyle(
                      color: Color(c3),
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
        onSelectPopupmenuItem(
            parentContext, popupMenuButtonItems[value]['name']);
      },
    );
  }
}
