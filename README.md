# UF2 Flashing for Linux

This repo contains scripts and patches to build a sample Linux image
based on [piCore](http://www.tinycorelinux.net/ports.html)
for the Raspberry Pi Zero.
The image is meant to boot very quickly (currently at around 7s),
and expose a USB mass storage device (pen drive), which can be used
to program a Raspberry Pi Zero with [UF2 files](https://github.com/Microsoft/uf2),
usually generated from [Microsoft MakeCode](https://github.com/Microsoft/pxt)
and in particular from [MakeCode Arcade](https://arcade.makecode.com).

The image was tested on a Raspberry Pi Zero Rev 1.3 and Zero W Rev 1.3.
It could theoretically work on the original Pi A/A+, but wasn't
tested. Other models lack the OTG ID pin, and thus cannot be used in
USB device mode.

PRs are welcome!

## Building

Building the image requires [Docker](https://www.docker.com/).

Go to `image/` and run `./build.sh`. The image will land in `built/boot/*`.

After you're done building, copy one of the `arcade.cfg` files in `cfg/` folder
to `built/boot/*` so that it ends up on the SD card.
You can also create your own `arcade.cfg` file if you have the buttons
connected differently.

### "Burning" image

All files in `built/boot/` need to be copied to a FAT32-formatted SD card.
There is no ext4 partition to worry about, and you don't need to use any
special software to "burn" the image.
The files need to sit in the root folder of the SD card, i.e.,
you should have file `d:/9.0.3.gz`, `d:/cmdline.txt`, as well
as `d:/arcade.cfg` (if your SD drive is `d:/`; on macOS it will
be `/Volumes/NO NAME/9.0.3.gz` etc).

Regular SD cards come preformatted as FAT32. If you have a previous
Raspberry Pi image on the card you can format it, or just move all files in
the first partition into a sub-folder if it's reasonably big.

Any SD card should do. You don't need much space (currently around 13MB),
and the Pi will only read a few MBs upon startup, so the speed isn't very important.

### Docker image

If you want to build the Docker image (`pext/rpi`) yourself,
use the `docker/build.sh` script. Usually, you can just pull it
from Docker Hub (which will just happen automatically).
The image is based on
[sdthirlwall/raspberry-pi-cross-compiler](https://hub.docker.com/r/sdthirlwall/raspberry-pi-cross-compiler/)
and contains stock piCore 9.0.3 and sources of its kernel.

### Menu program

Sources are here: `https://makecode.com/_f6oRRcMAf0T0`

## License

The contents of this repo are released under the MIT license.

The images that you build will contain software under all sorts of licenses, including GPL.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
