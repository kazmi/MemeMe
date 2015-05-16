//
//  Meme.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/16/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

/* 
    Comment by Sulaiman Azhar on 5/16/15.

    This structure represents the meme model. It includes 2 strings
    representing the top and bottom text, the original image and
    a memed image. A memed image combines the original image
    with the text.

    The meme structure instances receive a default
    memberwise initializer,

    let meme = Meme(topText: ...,
                    bottomText: ...,
                    image: ...,
                    memedImage: ...)

    An array of sent memes is maintained in the AppDelegate.swift

*/

struct Meme {
    var topText : String
    var bottomText : String
    var image : UIImage
    var memedImage : UIImage
}