// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/foundation.dart';

/// A controller for a tree state.
///
/// Allows to modify the state of the tree.
class TreeController {
  bool _allNodesExpanded;

  /// Whether the tree supports selecting multiple elements.
  bool multipleSelection;
  final Map<Key, bool> _expanded = <Key, bool>{};
  final Set<Key> _selected = {};

  TreeController({allNodesExpanded = true, this.multipleSelection = false})
      : _allNodesExpanded = allNodesExpanded;

  bool get allNodesExpanded => _allNodesExpanded;

  bool isNodeExpanded(Key key) {
    return _expanded[key] ?? _allNodesExpanded;
  }

  void toggleNodeExpanded(Key key) {
    _expanded[key] = !isNodeExpanded(key);
  }

  void expandAll() {
    _allNodesExpanded = true;
    _expanded.clear();
  }

  void collapseAll() {
    _allNodesExpanded = false;
    _expanded.clear();
  }

  void expandNode(Key key) {
    _expanded[key] = true;
  }

  void collapseNode(Key key) {
    _expanded[key] = false;
  }

  bool isSelected(Key key) => _selected.contains(key);

  void toggleSelection(Key key) {
    if (isSelected(key)) {
      _selected.remove(key);
    }

    _selected.add(key);
  }

  void select(Key key) {
    if (!multipleSelection) {
      _selected.clear();
    }
    _selected.add(key);
  }
}
