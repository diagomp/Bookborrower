# Bookborrower
### A simple application to export to PDF those documents that are not supposed to be exported in PDF
There are some book pages that let you visualize books but don't allow you to export them to PDF. Bookborrower solve this problem by systematically capturing screenshots of the pages and saving them as a PDF.

### How to use Bookborrower
#### Run the application (without coding)
If you don't want to mesh with code or download the Processing IDE, you can run this application as an .exe file. In this case follow this steps:
1. Download [bookborrower.exe(bookborrower.exe)]
2. Open the folder you downloaded it
3. Type 'cmd' in the path bar to open the windows command line.
4. In the console, type the following:
	``Bookborrower.exe "Name of file" num_pages``
	- "Name of file" is the name you want the file to have. You musn't include the extension. It must be in double quotes if your name have spaces in it.
	- num_pages is the total number of pages of the book you want to export.
#### Run the application (with coding)
If you already have the Processing IDE available in your PD, follow this steps:
1. Clone the project in your maching, or simpli create a new Processing project and copy the code there.
2. Change the value of the variables `bookName` and `numPages` with the name of the file and the number of pages, respectively.
3. Compile and run the application.
#### Getting the file created with Bookborroewer
Once you have the application running, follow this steps to actualy get your book exported. It is supposed you have the web page in wich with the book you want to export openned.
1. In the Bookborrower application window, position the mouse over the 'Next page' button in the web page your book is. Type 'c' to store this position.
2. Move the cursor to the first corner of the book page. Type 'h' for better positioning of the mouse. Once you are sure your mouse is rigth in the page corner, click the middle mouse button and keep it pressed.
3. Move the cursor again to the opposite corner of the page (use the 'h' utility if you want), and released the middle mouse button.
4. Last, you cand adjust the time the program will wait to capture each page to ensure it is loaded on the screen properly. Type directly the time, in seconds, you want to set with the keys 0 to 9.
5. Ensure the application window is not interfering with the page of the book itself, and type the UP key in your keyboard.
6. Wait until the program finishes. A PDF file will be generated with the name you specified in the folder the application is saved.

### Known issues
This app was developed rapidly to use its functionality as soon as posible. This means there is a lot of things to do to make it a usable application for the general public. Behind is a list of things I want to work on sooner or later.
-[] Create a Graphical User Interface for easy usage of the application and manipulation of the variables (title, number of pages...).
-[] Avoid having to locate the GUI in some strange position on the screen by hiding it when a screenshot is taken.
-[] Improve performance by reading the screen only when it is needed (when positioning the book page in the window, and when taking a screenshot).

### License
This project is [MIT Licensed(LICENSE)].
