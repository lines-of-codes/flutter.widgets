// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/material.dart';

/// One node of a tree.
class TreeNode {
  final List<TreeNode>? children;
  final Widget content;
  final Key? key;
  final bool lazy;
  final Future<List<TreeNode>> Function()? onExpandToggle;

  TreeNode(
      {this.key,
      this.children = const [],
      Widget? content,
      this.lazy = false,
      this.onExpandToggle})
      : content = content ?? Container(width: 0, height: 0);
}
