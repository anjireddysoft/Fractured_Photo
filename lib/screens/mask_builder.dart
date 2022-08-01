 import 'package:fractured_photo/model/tile.dart';

class TileBuilder {

   static List<Tile> loadTiles({required int patternType,required double wScaleFactor,required double hScaleFactor}) {
    List<Tile> maskList = [];

    if(patternType == 0){
      maskList.add(Tile(
        imageName: "mask_1",
        image: "assets/p1_mask_1.png",
        x1: 0,
        y1: 0,
        x2: 52,
        y2: 78,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_2",
        image: "assets/p1_mask_2.png",
        x1: 5,
        y1: 0,
        x2: 119,
        y2: 131,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_3",
        image: "assets/p1_mask_3.png",
        x1: 91,
        y1: 0,
        x2: 167,
        y2: 129,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_4",
        image: "assets/p1_mask_4.png",
        x1: 128,
        y1: 0,
        x2: 188,
        y2: 228,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_5",
        image: "assets/p1_mask_5.png",
        x1: 166,
        y1: 0,
        x2: 260,
        y2: 228,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_6",
        image: "assets/p1_mask_6.png",
        x1: 232,
        y1: 0,
        x2: 342,
        y2: 114,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_7",
        image: "assets/p1_mask_7.png",
        x1: 308,
        y1: 0,
        x2: 458,
        y2: 117,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_8",
        image: "assets/p1_mask_8.png",
        x1: 437,
        y1: 0,
        x2: 542,
        y2: 116,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_9",
        image: "assets/p1_mask_9.png",
        x1: 384,
        y1: 33,
        x2: 488,
        y2: 118,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false

      ));
      maskList.add(Tile(
        imageName: "mask_10",
        image: "assets/p1_mask_10.png",
        x1: 540,
        y1: 0,
        x2: 640,
        y2: 119,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_11",
        image: "assets/p1_mask_11.png",
        x1: 0,
        y1: 78,
        x2: 31,
        y2: 246,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_12",
        image: "assets/p1_mask_12.png",
        x1: 30,
        y1: 40,
        x2: 190,
        y2: 229,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_13",
        image: "assets/p1_mask_13.png",
        x1: 246,
        y1: 106,
        x2: 398,
        y2: 250,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_14",
        image: "assets/p1_mask_14.png",
        x1: 311,
        y1: 117,
        x2: 520,
        y2: 263,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_15",
        image: "assets/p1_mask_15.png",
        x1: 397,
        y1: 114,
        x2: 559,
        y2: 216,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_16",
        image: "assets/p1_mask_16.png",
        x1: 531,
        y1: 114,
        x2: 640,
        y2: 263,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_17",
        image: "assets/p1_mask_17.png",
        x1: 0,
        y1: 129,
        x2: 126,
        y2: 388,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_18",
        image: "assets/p1_mask_18.png",
        x1: 125,
        y1: 189,
        x2: 188,
        y2: 300,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_19",
        image: "assets/p1_mask_19.png",
        x1: 126,
        y1: 205,
        x2: 260,
        y2: 422,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false

      ));
      maskList.add(Tile(
        imageName: "mask_20",
        image: "assets/p1_mask_20.png",
        x1: 255,
        y1: 243,
        x2: 464,
        y2: 345,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_21",
        image: "assets/p1_mask_21.png",
        x1: 436,
        y1: 134,
        x2: 531,
        y2: 310,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_22",
        image: "assets/p1_mask_22.png",
        x1: 519,
        y1: 134,
        x2: 590,
        y2: 306,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_23",
        image: "assets/p1_mask_23.png",
        x1: 20,
        y1: 239,
        x2: 126,
        y2: 452,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_24",
        image: "assets/p1_mask_24.png",
        x1: 44,
        y1: 299,
        x2: 244,
        y2: 451,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_25",
        image: "assets/p1_mask_25.png",
        x1: 243,
        y1: 244,
        x2: 383,
        y2: 423,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_26",
        image: "assets/p1_mask_26.png",
        x1: 393,
        y1: 294,
        x2: 482,
        y2: 387,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_27",
        image: "assets/p1_mask_27.png",
        x1: 465,
        y1: 294,
        x2: 574,
        y2: 407,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_28",
        image: "assets/p1_mask_28.png",
        x1: 552,
        y1: 197,
        x2: 640,
        y2: 442,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false

      ));
      maskList.add(Tile(
        imageName: "mask_29",
        image: "assets/p1_mask_29.png",
        x1: 0,
        y1: 332,
        x2: 45,
        y2: 480,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_30",
        image: "assets/p1_mask_30.png",
        x1: 24,
        y1: 421,
        x2: 252,
        y2: 480,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_31",
        image: "assets/p1_mask_31.png",
        x1: 243,
        y1: 371,
        x2: 380,
        y2: 480,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_32",
        image: "assets/p1_mask_32.png",
        x1: 329,
        y1: 335,
        x2: 477,
        y2: 480,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_33",
        image: "assets/p1_mask_33.png",
        x1: 380,
        y1: 334,
        x2: 516,
        y2: 480,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_34",
        image: "assets/p1_mask_34.png",
        x1: 514,
        y1: 309,
        x2: 574,
        y2: 442,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));
      maskList.add(Tile(
        imageName: "mask_35",
        image: "assets/p1_mask_35.png",
        x1: 514,
        y1: 366,
        x2: 640,
        y2: 480,
        hScaleFactor: hScaleFactor,
        wScaleFactor: wScaleFactor,
        angle:0,
          isCenterPiece: false
      ));

    }else if(patternType == 1){
      maskList.add( Tile(imageName:"mask_1", image: "assets/p2_mask_1.png",  x1: 0,  y1:  0, x2: 59, y2:225,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_2", image: "assets/p2_mask_2.png",  x1: 9,  y1: 0,  x2:142, y2:205,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_3", image: "assets/p2_mask_3.png",  x1: 76,  y1:1,  x2:175, y2:268,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_4", image: "assets/p2_mask_4.png",  x1: 141, y1:0,  x2:224, y2:144,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_5", image: "assets/p2_mask_5.png",  x1: 129, y1:0,  x2:312, y2:242,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_6", image: "assets/p2_mask_6.png",  x1: 277, y1:0,  x2:418, y2:133,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_7", image: "assets/p2_mask_7.png",  x1: 323, y1:0,  x2:456, y2:137,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_8", image: "assets/p2_mask_8.png",  x1: 423, y1:0,  x2:565, y2:201,   hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_9", image: "assets/p2_mask_9.png",  x1: 551, y1:0,  x2:640, y2: 153,  hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_10",image: "assets/p2_mask_10.png", x1: 0,   y1:172,  x2:117, y2:413, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_11",image: "assets/p2_mask_11.png", x1: 109,  y1:111, x2: 228,y2: 301,hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_12",image: "assets/p2_mask_12.png", x1: 204,  y1:115, x2: 311,y2: 342,hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_13",image: "assets/p2_mask_13.png", x1: 227,  y1:44,  x2:324, y2:342, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_14",image: "assets/p2_mask_14.png", x1: 310,  y1:132, x2: 386,y2: 340,hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_15",image: "assets/p2_mask_15.png", x1: 358,  y1:99,  x2:483, y2:282, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_16",image: "assets/p2_mask_16.png", x1: 484,  y1:33,  x2:566, y2:277, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_17",image: "assets/p2_mask_17.png", x1: 553,  y1:55,  x2:640, y2:240, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_18",image: "assets/p2_mask_18.png", x1: 0,    y1:284,  x2:116,y2:480 ,hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_19",image: "assets/p2_mask_19.png", x1: 101,  y1:270,  x2:188,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_20",image: "assets/p2_mask_20.png", x1: 150,  y1:295,  x2:284,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_21",image: "assets/p2_mask_21.png", x1: 259,  y1:321,  x2:334,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_22",image: "assets/p2_mask_22.png", x1: 310,  y1:196,  x2:494,y2:341, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_23",image: "assets/p2_mask_23.png", x1: 309,  y1:289,  x2:453,y2:397, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_24",image: "assets/p2_mask_24.png", x1: 321,  y1:368,  x2:431,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_25",image: "assets/p2_mask_25.png", x1: 358,  y1:274,  x2:494,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_26",image: "assets/p2_mask_26.png", x1: 493,  y1:194,  x2:640,y2:354, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_27",image: "assets/p2_mask_27.png", x1: 448,  y1:371,  x2:553,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_28",image: "assets/p2_mask_28.png", x1: 472,  y1:278,  x2:592,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_29",image: "assets/p2_mask_29.png", x1: 564,  y1:266,  x2:640,y2:480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
    }else if(patternType == 2){
      maskList.add( Tile(imageName:"mask_1", image: "assets/p3_mask_1.png", x1:0,   y1:0,   x2:156, y2:179, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_2", image: "assets/p3_mask_2.png", x1:131, y1:00,  x2:275, y2:122, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_3", image: "assets/p3_mask_3.png", x1:133, y1:00,  x2:307, y2:212, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_4", image: "assets/p3_mask_4.png", x1:276, y1:00,  x2:361, y2:207, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_5", image: "assets/p3_mask_5.png", x1:319, y1:00,  x2:510, y2:157 ,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece: false));
      maskList.add( Tile(imageName:"mask_6", image: "assets/p3_mask_6.png", x1:455, y1:00,  x2:607, y2:234, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_7", image: "assets/p3_mask_7.png", x1:546, y1:00,  x2:640, y2:157, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_8", image: "assets/p3_mask_8.png", x1:0,   y1:122,  x2:68,y2: 293, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_9", image: "assets/p3_mask_9.png", x1:0,   y1:105,  x2:169, y2:350,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_10",image: "assets/p3_mask_10.png",x1: 306,y1: 39,  x2:462, y2:248,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_11",image: "assets/p3_mask_11.png",x1: 361,y1: 113, x2: 538,y2: 265,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0,isCenterPiece: true));
      maskList.add( Tile(imageName:"mask_12",image: "assets/p3_mask_12.png",x1: 546,y1: 96,  x2:640, y2:263,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_13",image: "assets/p3_mask_13.png",x1: 89, y1:196,  x2:216, y2:369,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_14",image: "assets/p3_mask_14.png",x1: 203,y1: 195, x2:372,y2: 417,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_15",image: "assets/p3_mask_15.png",x1: 362,y1: 247, x2:538,y2: 351,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_16",image: "assets/p3_mask_16.png",x1: 533,y1: 157, x2:587,y2: 361,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_17",image: "assets/p3_mask_17.png",x1: 204,y1: 201, x2:321,y2: 416,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_18",image: "assets/p3_mask_18.png",x1: 309,y1: 276, x2:377,y2: 429,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_19",image: "assets/p3_mask_19.png",x1: 369,y1: 276, x2:501,y2: 447,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:true));
      maskList.add( Tile(imageName:"mask_20",image: "assets/p3_mask_20.png",x1: 551,y1: 201, x2:640,y2: 450,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_21",image: "assets/p3_mask_21.png",x1: 00, y1:325,  x2:72, y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_22",image: "assets/p3_mask_22.png",x1: 28, y1:307,  x2:216,y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_23",image: "assets/p3_mask_23.png",x1: 100,y1: 368, x2:290,y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_24",image: "assets/p3_mask_24.png",x1: 260,y1: 395, x2:379,y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_25",image: "assets/p3_mask_25.png",x1: 369,y1: 278, x2:473,y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_26",image: "assets/p3_mask_26.png",x1: 451,y1: 249, x2:556,y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
      maskList.add( Tile(imageName:"mask_27",image: "assets/p3_mask_27.png",x1: 533,y1:337,  x2:640,y2: 480,hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,angle:0, isCenterPiece:false));
    }else{

      print("patterntype==$patternType");
    }
    return maskList;
  }

}