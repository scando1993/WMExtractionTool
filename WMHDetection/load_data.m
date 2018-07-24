function [ output_args ] = load_data( route, output_folder, raw_data_folder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tic
disp('Begin Load Data');

matlabroot = route;
data_folder = output_folder;
if ~exist(fullfile(matlabroot,data_folder),'dir')
    [status, message, messageid] = mkdir(fullfile(matlabroot),output_folder);
end

[filesA,dirsA] = spm_select('List', fullfile(raw_data_folder)); % select folders

parfor i=1  : length(dirsA(:,1))
    select_folderA = fullfile(raw_data_folder,deblank(dirsA(i,:)));
    [filesB,dirsB] = spm_select('List', select_folderA); % select contenido of each folder
    for j = 1:length(dirsB(:,1))
        select_folderB = fullfile(select_folderA, deblank(dirsB(j,:)));
        [filesC,dirsC] = spm_select('List', select_folderB); % select contenido of each folder
        k = 1;
        select_folderC = fullfile(select_folderB, deblank(dirsC(k,:)));
        try
            gunzip(select_folderC);
        catch
        end
        [filesD,dirsD] = spm_select('List', select_folderC); % select contenido of each folder
        for m = 1:length(filesD(:,1))
            [~,name,ext] = fileparts(filesD(m,:));
            if strcmp(deblank(name), 'T1')
                original_file = fullfile(select_folderC, deblank(filesD(m,:)));
                image_folder = fullfile(matlabroot, data_folder , deblank(dirsB(j,:)));
                [status, message, messageid] = mkdir(fullfile(matlabroot, data_folder), deblank(dirsB(j,:)));
                [status, message, messageid] = copyfile(original_file, image_folder);
            end
            if strcmp(deblank(name), 'FLAIR')
                original_file = fullfile(select_folderC, deblank(filesD(m,:)));
                image_folder = fullfile(matlabroot, data_folder , deblank(dirsB(j,:)));
                [status, message, messageid] = mkdir(fullfile(matlabroot, data_folder), deblank(dirsB(j,:)));
                [status, message, messageid] = copyfile(original_file, image_folder);
            end
        end
    end
end

disp('Done Load Data');
toc

end

