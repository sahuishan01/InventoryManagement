import 'package:flutter/material.dart';
import '../Models/auth.dart';
import '../Models/Chemicals/temp_chem_model.dart';
import './new_chemical.dart';
import '../Widgets/chemlist/single_chemical_card.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ChemicalList extends StatefulWidget {
  const ChemicalList({Key? key}) : super(key: key);
  static const routeName = "/chem_list";
  @override
  State<ChemicalList> createState() => _ChemicalListState();
}

class _ChemicalListState extends State<ChemicalList> {
  void newChemical(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(NewChemical.routeName, arguments: {'lab': lab.trim()});
  }

  List<ChemModel> tempList = [];
  var _init = true;
  var _isLoaded = false;
  @override
  void didChangeDependencies() async {
    if (_init) {
      setState(
        () {
          _isLoaded = true;
        },
      );
      Provider.of<ChemList>(context).getLoadedData().catchError(
        (onError) {
          print(onError);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not load content, try again later'),
          ));
        },
      ).then(
        (value) {
          setState(() {
            _init = false;
          });
        },
      );
    }

    tempList = Provider.of<ChemList>(context, listen: true).elements;

    super.didChangeDependencies();
  }

  final _scanController = TextEditingController();

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }
//scan for text

  //taking image
  Future<void> _takePicture() async {
    try {
      final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 600,
        maxWidth: 600,
        imageQuality: 100,
      );

      _cropImage(imageFile!.path);
    } catch (err) {
      _showError('Failed to capture image, please try again!!!');
      return;
    }
  }

  //cropping image
  void _cropImage(filePath) async {
    try {
      CroppedFile? croppedFile = await ImageCropper()
          .cropImage(sourcePath: filePath, maxHeight: 1000, maxWidth: 1000);
      InputImage inputImage = InputImage.fromFilePath(croppedFile!.path);

      processImage(inputImage);
    } catch (err) {
      _showError('Failed to crop image, please try again');
      return;
    }
  }

  // Processing cropped image for text

  String _text = '';
  final textRecognizer = TextRecognizer();
  Future<void> processImage(InputImage inputImage) async {
    setState(() {
      _text = '';
    });
    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            String tempString = element.text;
            _text += tempString;
          }
        }
      }
      if (_text == '') {
        _showError('Failed to identify text, try again');
        return;
      }
      _scanController.text = _text;
      searchText(_text);
      textRecognizer.close();
    } catch (err) {
      _showError('Can not find text from the image, try again!!!');
      return;
    }
  }

//handling errors
  void _showError(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error Occurred'),
              content: Text(msg),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okay'),
                ),
              ],
            ));
  }

//for searching elements by name
  void searchText(text) {
    setState(
      () {
        tempList =
            Provider.of<ChemList>(context, listen: false).findByName(text);
      },
    );
  }

  bool isAdmin = false;

  void checkAdmin() async {
    try {
      isAdmin = await Provider.of<Auth>(context, listen: false).isAdmin;
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An error Occurred'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Okay'),
                  ),
                ],
              ));
    }
  }

  Map userDetails = {'name': '', 'class': '', 'email': ''};
  void getUserDetails() async {
    try {
      userDetails = await Provider.of<Auth>(context, listen: false).userDetails;
      Map<String, dynamic>.from(userDetails);
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An error Occurred'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Okay'),
                  ),
                ],
              ));
    }
  }

  String lab = '';
  void labDetails() async {
    try {
      lab = await Provider.of<Auth>(context, listen: false).getLab;
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An error Occurred'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Okay'),
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin();
    labDetails();
    getUserDetails();
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    AppBar appBar = AppBar(
      backgroundColor: Colors.pink,
      leading: const Icon(Icons.science_outlined),
      title: const Text('Chemical List'),
      titleSpacing: 0,
      actions: <Widget>[
        FittedBox(
          fit: BoxFit.cover,
          child: TextButton(
              onPressed: () {},
              child: Text(
                userDetails['name'].toString().toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
    double appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: deviceHeight * 0.02),
              height: (deviceHeight - appBarHeight) * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Search
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(4, 4),
                              color: Colors.black26,
                              blurRadius: 5)
                        ],
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.pink),
                      ),
                      child: TextField(
                        controller: _scanController,
                        onChanged: (text) => searchText(text),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          hintText: "Search",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  //Scan
                  Expanded(
                    flex: 3,
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                        child: TextButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(19)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Scan",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () => _takePicture(),
                        )),
                  ),
                ],
              ),
            ),

            //Bottom bar for search and scan with Floating button for adding new elements
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                //Displaying all Chemicals
                SizedBox(
                  height: (deviceHeight - appBarHeight) * 0.8,
                  child: !_isLoaded
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: deviceHeight * 0.02),
                          itemCount: tempList.length,
                          itemBuilder: (ctx, index) =>
                              ChangeNotifierProvider.value(
                            value: tempList[index],
                            child: SingleChemicalCard(tempList, isAdmin, lab),
                          ),
                        ),
                ),
                isAdmin
                    ? FloatingActionButton(
                        splashColor: Colors.black54,
                        elevation: 10,
                        onPressed: () => newChemical(context),
                        child: const Icon(Icons.add),
                      )
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
