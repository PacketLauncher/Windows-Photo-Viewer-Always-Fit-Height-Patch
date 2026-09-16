# Windows-Photo-Viewer-Always-Fit-Height-Patch

* I've made sure that both installing and uninstalling scripts work as expected (tested on Windows 10 x64 22H2). That said, patching of operating system files is a subject to calamity which _can_ go wrong. Therefore, use at your own risk!

By default, the classic Windows Photo Viewer opens an image in its 1:1 scale when its size is _smaller_ than the window's preview area, or fits the image to it if it's larger. When viewing small pixel art graphics, the user requires to manually zoom-in to each and every image when navigating through them, making the process frustrating.

This small patch will make it automatically zoom-in to make the image fit the preview area, based on the current window's height.

Keep in mind that by default, the "Actual size" button (the icon to the right of the magnifying glass at the bottom toolbar) stores the 1:1 size of the loaded image, and serves as a _zoom-reset_ button if you happen to zoom-in on the image. After applying this patch, that button will dynamically store the image size shown in the preview! This means that clicking on it will just reset it to its current preview size - in order words, it will visually do nothing, and that's normal. Either way, the real file's image size will NOT be altered.

To install, run the batch file as Administrator. This will make a backup to the "C:\Program Files\Windows Photo Viewer\PhotoViewer.dll" file as "PhotoViewer.dll.bak" and then patch it.

To uninstall, run the uninstaller as Administrator. The "PhotoViewer.dll.bak" backup file will remain on disk, in case something goes wrong and you'd need to manually restore it.
