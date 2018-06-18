%[V,spatial,dim] = dicomreadVolume('./001');

img_path = '/Users/andreea/Documents/TU Wien/Master Medizinische Informatik/VisMed1/Project/pulmonary embolism/001';
datasets=dicom_folder_info(img_path,true); 