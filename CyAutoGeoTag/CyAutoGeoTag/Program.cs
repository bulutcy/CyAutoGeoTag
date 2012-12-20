using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ExifLibrary;
using System.Runtime.InteropServices;

namespace CyAutoGeoTag
{
    class Program
    {
        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [STAThread()]
        static void Main(string[] args)
        {
             setConsoleWindowVisibility(false, Console.Title);
            //for test:
           //  args = new[] { @"D:\Belgeler\Pictures\iPhone\237.JPG", @"D:\Belgeler\Pictures\iPhone\199.JPG", @"D:\Belgeler\Pictures\iPhone\200.JPG", @"D:\Belgeler\Pictures\iPhone\204.JPG", @"D:\Belgeler\Pictures\iPhone\205.JPG"};

           List<ImageFile> geoList = new List<ImageFile>();
           List<string> geoListLoc = new List<string>();
           List<ImageFile> nonGeoList = new List<ImageFile>();
           List<string> nonGeoListLoc = new List<string>();
            int i = 0;
            foreach (string arg in args)
            {
              //  Console.Write(arg);
                ImageFile file = null;
                try
                {
                    file = ImageFile.FromFile(arg);
                    GPSLatitudeLongitude location = file.Properties[ExifTag.GPSLatitude]
                                                  as GPSLatitudeLongitude;
                    geoList.Add(file);
                    geoListLoc.Add(arg);
                }
                catch (KeyNotFoundException e)
                {
                    nonGeoList.Add(file);
                    nonGeoListLoc.Add(arg);
                }
                catch (Exception e)
                {
                
                   
                }
                i++;

            }
            int iter = 0;
            int currentGeotag = 0;
            if (geoList.Count > 0)
            {
                while (iter != nonGeoList.Count)
                {
                    try
                    {
                        while ((currentGeotag + 1 != geoList.Count) &&
                            (Math.Abs(((System.DateTime)nonGeoList[iter].Properties[ExifTag.DateTime].Value).Subtract(((System.DateTime)geoList[currentGeotag].Properties[ExifTag.DateTime].Value)).TotalSeconds) >
                             Math.Abs(((System.DateTime)nonGeoList[iter].Properties[ExifTag.DateTime].Value).Subtract(((System.DateTime)geoList[currentGeotag + 1].Properties[ExifTag.DateTime].Value)).TotalSeconds))
                            )
                        {
                            currentGeotag++;
                        }
                    }
                    catch (Exception e)
                    {
                        while ((currentGeotag + 1 != geoList.Count) &&
                          (Math.Abs(((System.DateTime)nonGeoList[iter].Properties[ExifTag.DateTimeOriginal].Value).Subtract(((System.DateTime)geoList[currentGeotag].Properties[ExifTag.DateTimeOriginal].Value)).TotalSeconds) >
                           Math.Abs(((System.DateTime)nonGeoList[iter].Properties[ExifTag.DateTimeOriginal].Value).Subtract(((System.DateTime)geoList[currentGeotag + 1].Properties[ExifTag.DateTimeOriginal].Value)).TotalSeconds))
                          )
                        {
                            currentGeotag++;
                        }

                    }

                    //file2.Properties.Set(ExifTag.GPSLatitude, file.Properties.Values[ExifTag.GPSLatitude]);
                    nonGeoList[iter].Properties[ExifTag.GPSLatitude] = geoList[currentGeotag].Properties[ExifTag.GPSLatitude];
                    nonGeoList[iter].Properties[ExifTag.GPSLongitude] = geoList[currentGeotag].Properties[ExifTag.GPSLongitude];
                    //  file2.Properties[ExifTag.GPSIFDPointer] = file.Properties[ExifTag.GPSIFDPointer];
                    //  file2.Properties[ExifTag.GPSImgDirection] = file.Properties[ExifTag.GPSImgDirection];
                    //   file2.Properties[ExifTag.GPSImgDirectionRef] = file.Properties[ExifTag.GPSImgDirectionRef];
                    nonGeoList[iter].Properties[ExifTag.GPSLatitudeRef] = geoList[currentGeotag].Properties[ExifTag.GPSLatitudeRef];
                    nonGeoList[iter].Properties[ExifTag.GPSLongitudeRef] = geoList[currentGeotag].Properties[ExifTag.GPSLongitudeRef];
                    // file2.Properties[ExifTag.GPSTimeStamp] = file.Properties[ExifTag.GPSTimeStamp];
                    nonGeoList[iter].Save(nonGeoListLoc[iter]);
                    iter++;
                }
            }


        }
        public static void setConsoleWindowVisibility(bool visible, string title)
        {
            // below is Brandon's code            
            //Sometimes System.Windows.Forms.Application.ExecutablePath works for the caption depending on the system you are running under.           
            IntPtr hWnd = FindWindow(null, title);

            if (hWnd != IntPtr.Zero)
            {
                if (!visible)
                    //Hide the window                    
                    ShowWindow(hWnd, 0); // 0 = SW_HIDE                
                else
                    //Show window again                    
                    ShowWindow(hWnd, 1); //1 = SW_SHOWNORMA           
            }
        }
    }
}
