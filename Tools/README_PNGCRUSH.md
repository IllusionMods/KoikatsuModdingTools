# PNG Compression with pngcrush

The KoikatsuModdingTools now automatically compresses PNG files when building zipmods to reduce file sizes.

## Setup Instructions

To enable PNG compression, you need to download and place `pngcrush.exe` in this Tools directory.

### Download pngcrush

1. Download pngcrush for Windows from: https://sourceforge.net/projects/pmt/files/pngcrush/
2. Look for the latest version with a filename like `pngcrush-X.X.XX-w64.exe` (for 64-bit Windows)
3. Download the executable and place it in this `Tools` directory
4. The file should be named something like `pngcrush-1.8.13-w64.exe` or similar

### How It Works

When you build a zipmod, the tool will:
1. Look for `pngcrush*.exe` in the Tools directory
2. Automatically compress any PNG files (such as studio thumbnails) before adding them to the zipmod
3. Only keep the compressed version if it's smaller than the original
4. Log the compression results in the Unity console

### Benefits

- Reduces zipmod file sizes by 10-30% on average for PNG files
- No quality loss - compression is lossless
- Automatic - no manual intervention needed once pngcrush is set up

### Troubleshooting

If PNG compression fails:
- Check that pngcrush.exe is in the Tools directory
- Check the Unity console for error messages
- The build will continue with uncompressed PNGs if pngcrush is not found
