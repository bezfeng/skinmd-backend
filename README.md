skinmd-backend
=============

Matlab code that periodically scans for new images and conducts analysis to detect the presence of melanoma and basal cell carcinoma.

## Usage

This script is intended to be used as a long running daemon on a server. 

1. Open the ServerAnalysis.m file and change resultsFile and imageDir to a file and directory of your choice. The imageDir is the folder where Matlab will periodically scan for new files, while the resultsFile is where the analysis results will go.

2. Start the daemon by running (for example):
	hup matlab -r ServerAnalysis -nojvm -nodisplay -logfile logs/mat.log > /dev/null &
We start Matlab with no display and no Java virtual machine to reduce memory usage. All output will be logged in logs/mat.log while console output will be piped to /dev/null (i.e. ignored).

3. After analysis has finished, the script moves any processed images into a "processed/" directory in the same folder as the script. Check your resultsFile for the results. A '1' next to the file name means there was no melanoma detected. A '2' means possible melanoma, a '3' means basal cell carcinoma, and a '4' means the results were ambiguous. 

## License

All code is released under the MIT license. 

Copyright (c) 2013 Bezhou Feng, Aldrin Abastillas, Lisa Jiang, and Ryan Nakasone.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
