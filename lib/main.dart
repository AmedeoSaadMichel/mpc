import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'custom_widgets.dart';
import 'package:dio/dio.dart';
import 'bloc/feature_bloc.dart';

void main() {
  runApp( BlocProvider(
      create: (context)=>ImageBloc(),
      child: MyApp()));
}

//CONST
const myColorButton = Color.fromRGBO(165, 212, 66, 1);
const myColorScreen = Color.fromRGBO(242, 245, 247, 1);
const myBorderSideGrey = BorderSide(color: Colors.grey);
const myTextStylegrey = TextStyle(color: Colors.grey);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //BLOC----------------------------------------


  //BLOC----------------------------------------
  final _formKey = GlobalKey<FormState>(); //FORM KEY
  //CONTROLLERS--------------------------------------------------------------------------------
  final TextEditingController _commentInputController = TextEditingController();
  final TextEditingController _areaInputController = TextEditingController();
  final TextEditingController _taskInputController = TextEditingController();
  final TextEditingController _tagsInputController = TextEditingController();
  final TextEditingController _eventInputController = TextEditingController();
  final TextEditingController _calendarInputController = TextEditingController();
  //--------------------------------------------------------------------------------
  //VARIABLES-----------------------------------------------------------------------
  //CALENDAR
  DateTime? _selectedDate;

  //IMAGES
  List<XFile>? _images = [];

  //CHECKBOX
  bool isCheckedGallery = false;
  bool isCheckedEvent = false;
  //--------------------------------------------------------------------------------
  //function to pick up images from the gallery
/*  Future<void> _pickImages() async {
    List<XFile>? pickedImages =
        await ImagePicker().pickMultiImage(imageQuality: 50);

    setState(() {
      _images = pickedImages;
    });
  }*/


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return BlocBuilder<ImageBloc,ImageState>(
      builder: (context,state)
      {
        return  Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text("New Diary"),
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          body: Center(
            child: Container(
              color: myColorScreen,
              child: Column(
                children: [
                  _location(h, w),
                  _addToSiteDiary(),
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: ListView(
                        children: [
                          _addPhotosToSiteDiary(h, w),
                          _commentsSection(h, w),
                          _detailsSection(h, w),
                          _linkToExistingEventSection(h, w),
                          _nextButton(h, w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
//WIDGETS--------------------------------------------------------------------------------
  Widget _location(double h, double w) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(h * 0.03),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            color: Colors.grey[700],
          ),
          VerticalDivider(
            width: w * 0.01,
          ),
          const Text(
            "20041075 | TAP-NS TAP-North Strathfield",
          ),
        ],
      ),
    );
  }

  Widget _addToSiteDiary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Add to site diary",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.question_circle_fill,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _addPhotosToSiteDiary(double h, double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
      child: ReusableCard(
        title: "Add Photos to site diary",
        height: h * 0.5,
        width: w * 0.8,
        children: [
          //HERE I GIVE THE HEIGHT OTHERWISE WILL
          // THROWN AN ERROR FOR UNBOUNDED HEIGHT
          _buildImageList(h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.01),
            child: CButton(
              text: 'Add a photo',
              onPressed: () async {
                context.read<ImageBloc>().pickImages();
              },
              buttonColor: myColorButton,
              height: h,
              width: w,
            ),
          ),

          //include in photo gallery
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: w * 0.05),
                child: const Text(
                  "include in photo gallery",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Spacer(),
              Checkbox(
                activeColor: Colors.lightGreenAccent,
                value: isCheckedGallery,
                onChanged: (value) {
                  setState(() {
                    isCheckedGallery = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commentsSection(double h, double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: h * 0.01),
      child: ReusableCard(
        title: "Comments",
        height: h * 0.2,
        width: w * 0.8,
        children: [
          Container(
            padding:
                EdgeInsets.only(top: h * 0.02, left: h * 0.02, right: h * 0.02),
            child: TextFormField(
              controller: _commentInputController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: myBorderSideGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Comment',
                hintStyle: myTextStylegrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsSection(double h, double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: h * 0.01),
      child: ReusableCard(
        title: "Details",
        height: h * 0.6,
        width: w * 0.8,
        children: [
          Container(
            padding: EdgeInsets.all(h * 0.02),
            child: TextFormField(
              controller: _calendarInputController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: myBorderSideGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Date',
                hintStyle: myTextStylegrey,
                suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _calendarInputController.text =
                            "${pickedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(h * 0.02),
            child: TextFormField(
              controller: _areaInputController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: myBorderSideGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Select Area',
                hintStyle: myTextStylegrey,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(h * 0.02),
            child: TextFormField(
              controller: _taskInputController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: myBorderSideGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Task Category',
                hintStyle: myTextStylegrey,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(h * 0.02),
            child: TextFormField(
              controller: _tagsInputController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: myBorderSideGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Tags',
                hintStyle: myTextStylegrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkToExistingEventSection(double h, double w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ReusableCard(
        title: "Link to existing event?",
        height: h * 0.15,
        width: w * 0.8,
        titleStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        titleRowWidget: [
          const Spacer(),
          Checkbox(
            activeColor: Colors.lightGreenAccent,
            value: isCheckedEvent,
            onChanged: (value) {
              setState(() {
                isCheckedEvent = value!;
              });
            },
          ),
        ],
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _eventInputController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: myBorderSideGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Select an event',
                hintStyle: myTextStylegrey,
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextButton(double h, double w) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.01),
      child: CButton(
        text: 'Next',
        onPressed: () async {
          // TODO: ADD THE FUNCTION TO UPLOAD THE PHOTOS
          if (_formKey.currentState!.validate()) {
            // Process the form data
            // i access the entered values using _Controller.text,

            final dio = Dio();
            final formData = FormData.fromMap({
              'images': _images,
              'includePhotos': isCheckedGallery,
              'comment': _commentInputController.text,
              'date': _calendarInputController.text,
              'area': _areaInputController.text,
              'task': _taskInputController.text,
              'tags': _tagsInputController.text,
              'linkEvent': isCheckedEvent,
              'event': _eventInputController.text,
            });
            try {
              final response =
                  await dio.post('https://reqres.in/api/users', data: formData);
              print(response.data); // Handle the response as needed
            } catch (error) {
              print('Error uploading : $error');
            }

            print('Form submitted!');
          }
        },
        buttonColor: myColorButton,
        height: h,
        width: w,
      ),
    );
  }

  Widget _buildImageList(h) {
    return BlocBuilder<ImageBloc,ImageState>(
      builder: (context,state) {
        if (state is ImagesLoadedState){

          return SizedBox(
            height: h * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.file(
                          state.images[index],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                          //  _images!.removeAt(index);
                            BlocProvider.of<ImageBloc>(context).deleteImage(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else{
          return Container();
        }
      }
    );
  }
//--------------------------------------------------------------------------------
}
