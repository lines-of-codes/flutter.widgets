// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/material.dart';

import 'builder.dart';
import 'primitives/tree_controller.dart';
import 'primitives/tree_node.dart';

/// Widget that displays one [TreeNode] and its children.
class NodeWidget extends StatefulWidget {
  final TreeNode treeNode;
  final double? indent;
  final double? iconSize;
  final TreeController state;

  const NodeWidget(
      {Key? key,
      required this.treeNode,
      this.indent,
      required this.state,
      this.iconSize})
      : super(key: key);

  @override
  _NodeWidgetState createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool get _isLeaf {
    return !widget.treeNode.lazy &&
        (widget.treeNode.children == null || widget.treeNode.children!.isEmpty);
  }

  bool get _isExpanded {
    return widget.state.isNodeExpanded(widget.treeNode.key!);
  }

  bool get _isSelected {
    return widget.state.isSelected(widget.treeNode.key!);
  }

  Future<List<TreeNode>>? future;

  @override
  void initState() {
    super.initState();

    if (widget.treeNode.onExpandToggle != null) {
      future = widget.treeNode.onExpandToggle!();
    }
  }

  void onSelect() {
    widget.state.toggleSelection(widget.treeNode);
  }

  Widget getChildren() {
    if (widget.treeNode.lazy) {
      return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<TreeNode> children = widget.treeNode.children ?? [];

              children = [...children, ...snapshot.data as List<TreeNode>];

              return Padding(
                padding: EdgeInsets.only(left: widget.indent!),
                child: buildNodes(widget.treeNode.children!, widget.indent,
                    widget.state, widget.iconSize),
              );
            }

            return CircularProgressIndicator();
          });
    }

    return Padding(
      padding: EdgeInsets.only(left: widget.indent!),
      child: buildNodes(widget.treeNode.children!, widget.indent, widget.state,
          widget.iconSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    var icon = _isLeaf
        ? null
        : _isExpanded
            ? Icons.expand_more
            : Icons.chevron_right;

    var onIconPressed = _isLeaf
        ? null
        : () => setState(
            () => widget.state.toggleNodeExpanded(widget.treeNode.key!));

    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              iconSize: widget.iconSize ?? 24.0,
              icon: Icon(icon),
              onPressed: onIconPressed,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isSelected ? theme.highlightColor : null,
                ),
                child: widget.treeNode.content,
              ),
              onTap: onSelect,
            ),
          ],
        ),
        if (_isExpanded && !_isLeaf) getChildren()
      ],
    );
  }
}
