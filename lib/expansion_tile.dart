import 'package:flutter/material.dart' hide ExpansionTile;

const _kExpand = Duration(milliseconds: 200);

class ExpansionTile extends StatefulWidget {
  const ExpansionTile(
      {Key? key, required this.title, this.initiallyExpanded = false})
      : super(key: key);

  final Widget title;
  final bool initiallyExpanded;

  @override
  State<ExpansionTile> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late AnimationController _animationController;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_easeInTween);

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _toggleExpansion();
  }

  void _toggleExpansion() {
    final TextDirection textDirection =
        WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String stateHint =
        _isExpanded ? localizations.expandedHint : localizations.collapsedHint;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileThemeData =
        ExpansionTileTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTileTheme.merge(
          child: ListTile(
            onTap: _handleTap,
            title: widget.title,
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.topLeft,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _animationController.isDismissed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: ColoredBox(
          color: Colors.green,
          child: SizedBox.fromSize(
            size: Size.fromHeight(400),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: result,
    );
  }
}
