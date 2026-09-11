import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/core/theme/app_pallete.dart';
import 'package:resona/core/utils.dart';
import 'package:resona/core/widgets/custom_field.dart';
import 'package:resona/core/widgets/loader.dart';
import 'package:resona/features/home/view/widgets/audio_wave.dart';
import 'package:resona/features/home/viewmodel/home_viewmodel.dart';

class UploadSongPage extends ConsumerStatefulWidget{
  const UploadSongPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File?selectedImage;
  File?selectedAudio;
  final formKey = GlobalKey<FormState>();
  void selectAudio() async{
    final pickedAudio = await pickAudio();
    if(pickedAudio != null){
      setState(() {
        selectedAudio = pickedAudio;
      });

    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if(pickedImage != null){
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    songNameController.dispose();
    artistController.dispose();
  }
@override
  Widget build(BuildContext context){
    final isLoading = ref.watch(homeViewmodelProvider.select((val)=> val?.isLoading == true));
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        scrolledUnderElevation: 0,                        // update song mei jo upper color change ho rha tha ise shi hua vo
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () async {
              if(formKey.currentState!.validate() && selectedAudio != null && selectedImage != null ){
                ref.read(homeViewmodelProvider.notifier).uploadSong(
                    selectedAudio: selectedAudio!,
                    selectedThumbnail: selectedImage!,
                    songName: songNameController.text,
                    artist: artistController.text,
                    selectedColor: selectedColor);
              } else {
                showSnackBar(context, 'Missing fields!');
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
        // package for color picker
        // dotted border 2.1.0
      ),

      body: isLoading
          ? const Loader()
          : ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                overscroll: false,
                physics: const ClampingScrollPhysics(),

              ),
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: selectImage ,
                            child: selectedImage != null
                                ? SizedBox( height:180,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  )
                                :  DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  color: Pallete.borderColor,
                                  dashPattern: [10, 4],
                                  strokeWidth: 1,
                                  radius: const Radius.circular(10),
                                  strokeCap: StrokeCap.round,
                                ),
                                child: const SizedBox(
                                  height: 140,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 15,),
                                      Text('Select the thumbnail for your song', style: TextStyle(fontSize: 15),),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          SizedBox(height: 34,),
                          selectedAudio!=null
                              ? Row(
                            children: [
                              Expanded(
                                child: AudioWave(path: selectedAudio!.path),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    selectedAudio = null;   // Audio hata diya
                                  });
                                },
                              ),
                            ],
                          )
                              : CustomField(
                               hintText: 'Pick Song',
                               controller: null,
                               readOnly: true,
                               onTap: selectAudio,
                              ),
                          SizedBox(height: 20,),
                          CustomField(
                              hintText: 'Artist',
                              controller: artistController,
                          ),
                          SizedBox(height: 20,),
                          CustomField(
                              hintText: 'Song Name',
                              controller: songNameController,
                          ),
                          SizedBox(height:10),
                          ColorPicker(
                            pickersEnabled: {
                              ColorPickerType.wheel:true,
                            },
                            color: selectedColor,
                              onColorChanged: (Color color){
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
          ),
    );
  }
}