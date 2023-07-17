import 'package:flutter/material.dart';

import '../constants/constants.dart';
class LoadingComponent extends StatelessWidget {
  const LoadingComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(

      child:  CircularProgressIndicator(),
    );
  }
}

