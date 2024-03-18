import 'dart:async';
import 'dart:math';
import 'package:untitled/Http/Models.dart';

class Node {
  Coordinates point;
  Node? leftChild;
  Node? rightChild;

  Node(this.point, {this.leftChild, this.rightChild});
}

class KdTree {
  Node? root;

  KdTree() {
    root = null;
  }

  void buildTree(List<Coordinates> points) {
    root = _buildKdTree(points);
  }

  Node? _buildKdTree(List<Coordinates> points, [int depth = 0]) {
    if (points.isEmpty) {
      return null;
    }

    int axis = depth % 2;
    points.sort((a, b) =>
    axis == 0 ? a.latitude.compareTo(b.latitude) : a.longitude.compareTo(b.longitude));

    int medianIndex = points.length ~/ 2;
    Coordinates median = points[medianIndex];

    return Node(
      median,
      leftChild: _buildKdTree(points.sublist(0, medianIndex), depth + 1),
      rightChild: _buildKdTree(points.sublist(medianIndex + 1), depth + 1),
    );
  }

  Coordinates findNearestNeighbor(Coordinates target) {
    if (root == null) {
      throw Exception("Kd-tree is not built yet");
    }
    return _nearestNeighborHelper(root!, target, double.infinity)!;
  }

  Coordinates? _nearestNeighborHelper(Node node, Coordinates target, double bestDistance) {
    if (node == null) {
      return null;
    }

    double currentDistance = distance(node.point, target);

    if (currentDistance < bestDistance) {
      bestDistance = currentDistance;
    }

    int axis = _getAxis(node);
    double axisDistance =
    axis == 0 ? target.latitude - node.point.latitude : target.longitude - node.point.longitude;

    Node? nearChild = axisDistance < 0 ? node.leftChild : node.rightChild;
    Node? farChild = axisDistance < 0 ? node.rightChild : node.leftChild;

    Coordinates best = node.point;
    Coordinates? candidate = _nearestNeighborHelper(nearChild!, target, bestDistance);
    if (candidate != null && distance(candidate, target) < bestDistance) {
      best = candidate;
      bestDistance = distance(candidate, target);
    }

    if (axisDistance * axisDistance < bestDistance) {
      candidate = _nearestNeighborHelper(farChild!, target, bestDistance);
      if (candidate != null && distance(candidate, target) < bestDistance) {
        best = candidate;
      }
    }

    return best;
  }

  int _getAxis(Node node) {
    return node == null ? -1 : node.point.latitude != node.point.longitude ? 0 : 1;
  }

  double distance(Coordinates a, Coordinates b) {
    return sqrt(pow(a.latitude - b.latitude, 2) + pow(a.longitude - b.longitude, 2));
  }
}