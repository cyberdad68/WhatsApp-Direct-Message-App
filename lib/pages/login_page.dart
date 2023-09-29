// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  var adUnit = "ca-app-pub-5973362440731172/9966424351";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initbannerAd();
  }

  _initbannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          _isAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
      request: AdRequest(),
    );
    _bannerAd.load();
  }

  TextEditingController phoneNumberController = TextEditingController();
  bool ChangeButton = false;
  final _formKey = GlobalKey<FormState>();

  sendMessage(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        ChangeButton = true;
      });
      await Future.delayed(Duration(milliseconds: 400));
      final String phoneNumber = phoneNumberController.text;
      final Uri url = Uri.parse('https://wa.me/$phoneNumber');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch');
      }
      setState(() {
        ChangeButton = false;
      });
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 25.0,
              ),
              Image.asset("assets/images/login_image.png", fit: BoxFit.cover),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        20.0), // Adjust the horizontal padding as needed
                child: Text(
                  "You can add any number and chat with them on WhatsApp without saving their number.",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              const Text(
                "Mobile Number",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 86, 23)),
              ),
              const Text(
                "(Including country code)",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        hintText: "Eg: +911234567890",
                        labelText: "Enter Phone Number",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone Number cannot be empty";
                        } else if (value.length <= 10) {
                          return "Phone Number must be 10 digits excluding country code";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      color: Color.fromARGB(255, 19, 86, 23),
                      borderRadius:
                          BorderRadius.circular(ChangeButton ? 50 : 8),
                      child: InkWell(
                        onTap: () => sendMessage(context),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: ChangeButton ? 50 : 210,
                          height: 50,
                          alignment: Alignment.center,
                          child: ChangeButton
                              ? const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              : const Text(
                                  "OPEN IN WHATSAPP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 110.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: _isAdLoaded
                          ? Container(
                              height: 50,
                              child: AdWidget(
                                ad: _bannerAd,
                              ),
                            )
                          : const SizedBox(
                              height: 50,
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
