import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogImage {
  Future<void> dialogBuilder(BuildContext context, List<String> listaUrl) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            List<Future<void>> futures = listaUrl.map((url) {
              return precacheImage(NetworkImage(url), context);
            }).toList();

            return AlertDialog(
              title: const Text('Immagini'),
              content: SizedBox(
                height: 200,
                child: FutureBuilder(
                  future: Future.wait(futures),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          children: [
                            for (int i = 0; i < listaUrl.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.network(
                                  listaUrl[i],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Chiudi'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}