# Image-J-macros
// This macro converts Leica .lif files into Z-projects (different methods possible) and saves them into same folder.
// Macro works for .lif files with more than 1 series. However, for large datasets, fast computers and more memory acquired to ImageJ maybe required.
// (c) Vibhu Prasad, University of Zurich, 
// Last edit: 180815; 2.36pm
// log: moved makedirectory to the last for loop which slowed the whole script down enough that the speed issue with projecting and saving files is not happening now.
// log: changed the way images are read for saving. Now a fow loop loads all open images (including Max projects, split channels) and checks if images start with C. Then saves it, else if they not, it closes them. So finally one will end only with C images. No error on Office Mac2!!
// log: site information for tilescans work now :)

print ("start");

ReadPath = getDirectory("Choose a Directory");
WritePath = getDirectory("Choose a Directory");

//create a new directory for the processed images

processedDir=WritePath+"Z-Project_PNG";
File.makeDirectory(processedDir);

//get the path from user input

list = getFileList(ReadPath);

for(i=0; i<=list.length-1; i++)
{
                if (endsWith(list[i], ".lif"))
                                dirList = Array.concat(dirList, list[i]);
		else
				print("ReadPath contains other files/folder");
				//exit();
}

Array.print(dirList);

for(j=1; j<=dirList.length-1; j++)
{
	path=ReadPath+dirList[j];
	//run("Bio-Formats", "open=[path] color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
	run("Bio-Formats", "open=[path] color_mode=Default open_all_series view=Hyperstack stack_order=XYCZT use_virtual_stack");

//returns the number of open images
}
names = newArray(nImages); 
ids = newArray(nImages); 	

for (l=0; l < ids.length; l++)
{ 
selectImage(l+1); 
ids[l] = getImageID(); 
names[l] = getTitle(); 
rename(names[l] + "_s" +l);
//newprocessedDir = processedDir+File.separator+names[l];
run("Z Project...", "projection=[Max Intensity]"); //Change here the projection format

run("Split Channels");	//Change here if the image is not multichannel image
}
newnames = newArray(nImages); 
newids = newArray(nImages); 	

for (i=0; i < newids.length; i++)
{ 

//selectImage(i+1); 
newids[i] = getImageID(); 
newnames[i] = getTitle(); 

if (startsWith(newnames[i], "C")) //Change here for the common image identifier
{
	print ("File found, saving and closing");
	run("Enhance Contrast...", "saturated=0.4");
	//run("16-bit"); //Change here if want to change image format
	setMinAndMax(204, 1023);
	saveAs("PNG", processedDir+File.separator+newnames[i]);
	
	close();
}
else
{
	print ("File not found, closing");
	close();
}

}




//close("*");

print ("end");
