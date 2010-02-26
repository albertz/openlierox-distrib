Liero Xtreme Level Maker v1.2
By Auxiliary Software 2002
By OpenLieroX dev team 2009

http://openlierox.net/

Contents
1) Description
2) How to use it
3) Contact


1) Description
--------------
The level maker is a simple program that grabs three image files and converts them into a single file that can be played as a level in Liero Xtreme.

The three images do different things:

a) Front image
The front image is what is used for pixels that have dirt or rock flags.

b) Back image
The back image is what is used for pixels that have no dirt or rock flags.

c) Material image
The material image specifies what the pixels are. Pixels can be one of three types. Dirt, Rock or empty.
Different colours are used in the material image to represent different pixel types:

(In RGB colour format)
Dirt = 255,255,255
Rock = 128,128,128
Empty = 0, 0, 0

All three images must be exactly the same image size.

d) Hi-res front and back images (optional)
The same as front and back images, but with possibility to add more detail - 
the level won't look pixelated if you include these images. They will be shown instead of low-res images,
but material image is the same for both hi-res and low-res versions.
Hi-res images are supported since OpenLieroX 0.58, old LX will just show low-res images 2x scaled up.
Hi-res images should be exactly twice the size of other three images.


2) How to use it
----------------
1) Run the exe file
2) Click on the browse buttons and find the appropriate images
3) Enter in a name
4) Click on the compile button and save the level

The level file should have the extension *.lxl so that Liero Xtreme can see that it is a possible level.

The images can be in any of the following image formats:
PNG, JPEG, PCX, BMP, TGA, GIF

However, storing material files in lossy file formats (jpeg, gif) may result in slight value changes in the colour which would cause the material file to be not processed correctly.

PNG, PCX, BMP or TGA file formats would be the best formats to use for all three image files.

After running the level maker, put the newly created *.lxl file in the Levels directory located in the Liero Xtreme directory.
Load up Liero Xtreme, select your level from the list, and play!


3) Contact
Send mail to openlierox-devel@lists.sourceforge.net
