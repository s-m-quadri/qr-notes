import 'package:flutter/material.dart';

class RenderPlaceholder extends StatefulWidget {
  const RenderPlaceholder(
      {Key? key,
      this.icon = Icons.warning_amber,
      this.text = "Page Not Defined"})
      : super(key: key);

  final IconData icon;
  final String text;

  @override
  State<RenderPlaceholder> createState() => _RenderPlaceholderState();
}

class _RenderPlaceholderState extends State<RenderPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Icon(
            widget.icon,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10),
          Column(
            children: [
              SizedBox(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                width: 256,
              ),
              SizedBox(height: 4),
              SizedBox(
                child: Text(
                  """This is just a placeholder for the application. And will change on each iteration in development lifecycle.""",
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                width: 256,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      height: 100,
    );
  }
}
