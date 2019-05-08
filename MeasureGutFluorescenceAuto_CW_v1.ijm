//For measuring gut fluorescence - thresholding and measurement using 3D object couter
//Example data provided
//Put all your images in one folder
//Output is object map and excel spreadsheet showing measured values
//First, use 3D object counter to optimize threshold
Threshold =30;//You need to set the threshold manually 
minobjsize = 100; //objects below this size will be discarded

source_dir = getDirectory("Source Directory");
target_dir = getDirectory("Target Directory");

run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid mean_distance_to_surface std_dev_distance_to_surface median_distance_to_surface centre_of_mass bounding_box dots_size=5 font_size=30 show_numbers white_numbers store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");

setBatchMode(true)

list = getFileList(source_dir);
list = Array.sort(list);

	for (i=0; i<list.length; i++) {

		Image = source_dir + list[i];
		open(Image);

		run("8-bit");
		Name = getTitle();
		run("3D Objects Counter", "threshold=" + Threshold + " slice=1 min.=" + minobjsize + " max.=1440000 objects statistics summary");

		selectWindow("Objects map of " + Name);
		saveAs("tiff", target_dir + "/" + Name + "_ObjectMap.tiff");

		selectWindow("Statistics for " + Name);
		saveAs("Text", target_dir + "/" + Name + "_Statistics.xls");

		run("Close All");
	}