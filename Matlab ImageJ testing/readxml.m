% this .m file reads key parameters from .xml file produced by PairieView
[file_name,path]=uigetfile();
complete_path=[path,file_name];
tree=parseXML(complete_path);
pixel_size=str2num(tree.Children(4).Children(26).Children(2).Attributes(2).Value);
frame_rate=str2num(tree.Children(4).Children(14).Attributes(2).Value);

