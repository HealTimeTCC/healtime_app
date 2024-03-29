import 'package:flutter/material.dart';
import 'package:healtime/shared/decorations/fonts_google.dart';
import 'package:provider/provider.dart';

import '../../../../../../../services/provider/queries/provider_queries.dart';
import '../../../../../../../shared/dto/dto_post_query.dart';

class LogicQueries {
  static Future<void> postQuery({
    required BuildContext context,
    required PostQuery postQuery,
  }) async {
    try {
      final ProviderQueries providerQuery =
          Provider.of<ProviderQueries>(context, listen: false);
      final Size size = MediaQuery.of(context).size;

      if (postQuery.flagForwarding == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Text(
              'É obrigatório a informação do encaminhamento.',
              style: FontGoogle.textNormaleGoogle(
                  size: size * .7, colorText: Colors.white),
            ),
          ),
        );
        return;
      }

      await providerQuery.postQuery(context: context, postQuery: postQuery);

      providerQuery.disposeDoctor();
    } catch (ex) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
            content: Text(
              ex.toString(),
            ),
          ),
        );
      }
    }
  }
}
